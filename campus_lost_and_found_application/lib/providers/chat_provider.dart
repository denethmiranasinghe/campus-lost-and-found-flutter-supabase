import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';

/// Chat Provider
/// Handles real-time messaging functionality
class ChatProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  RealtimeChannel? _messageSubscription;

  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch all chats for current user
  Future<void> fetchChats(String currentUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('chats')
          .select(
            '*, users!chats_user_id_1_fkey(full_name, email), users!chats_user_id_2_fkey(full_name, email)',
          )
          .or('user_id_1.eq.$currentUserId,user_id_2.eq.$currentUserId')
          .order('last_message_time', ascending: false);

      _chats = (response as List).map((chat) {
        final chatModel = ChatModel.fromJson(chat);

        // Determine the other user
        final isUser1 = chat['user_id_1'] == currentUserId;
        final otherUserData = isUser1
            ? chat['users!chats_user_id_2_fkey']
            : chat['users!chats_user_id_1_fkey'];

        if (otherUserData != null) {
          return ChatModel(
            id: chatModel.id,
            userId1: chatModel.userId1,
            userId2: chatModel.userId2,
            lastMessage: chatModel.lastMessage,
            lastMessageTime: chatModel.lastMessageTime,
            createdAt: chatModel.createdAt,
            otherUserName: otherUserData['full_name'],
            otherUserEmail: otherUserData['email'],
            unreadCount: chatModel.unreadCount,
          );
        }
        return chatModel;
      }).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch chats: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get or create chat between two users
  Future<String?> getOrCreateChat(String userId1, String userId2) async {
    try {
      // Check if chat already exists
      final existingChat = await _supabase
          .from('chats')
          .select()
          .or(
            'and(user_id_1.eq.$userId1,user_id_2.eq.$userId2),and(user_id_1.eq.$userId2,user_id_2.eq.$userId1)',
          )
          .maybeSingle();

      if (existingChat != null) {
        return existingChat['id'] as String;
      }

      // Create new chat
      final newChat = await _supabase
          .from('chats')
          .insert({
            'user_id_1': userId1,
            'user_id_2': userId2,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return newChat['id'] as String;
    } catch (e) {
      _errorMessage = 'Failed to create chat: $e';
      notifyListeners();
      return null;
    }
  }

  /// Fetch messages for a specific chat
  Future<void> fetchMessages(String chatId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('messages')
          .select('*, users!messages_sender_id_fkey(full_name)')
          .eq('chat_id', chatId)
          .order('created_at', ascending: true);

      _messages = (response as List).map((message) {
        final messageModel = MessageModel.fromJson(message);
        if (message['users'] != null) {
          return MessageModel(
            id: messageModel.id,
            chatId: messageModel.chatId,
            senderId: messageModel.senderId,
            receiverId: messageModel.receiverId,
            message: messageModel.message,
            createdAt: messageModel.createdAt,
            isRead: messageModel.isRead,
            senderName: message['users']['full_name'],
          );
        }
        return messageModel;
      }).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch messages: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Subscribe to real-time messages
  void subscribeToMessages(String chatId) {
    _messageSubscription?.unsubscribe();

    _messageSubscription = _supabase
        .channel('messages:$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: (payload) {
            final newMessage = MessageModel.fromJson(payload.newRecord);
            _messages.add(newMessage);
            notifyListeners();
          },
        )
        .subscribe();
  }

  /// Unsubscribe from real-time messages
  void unsubscribeFromMessages() {
    _messageSubscription?.unsubscribe();
    _messageSubscription = null;
  }

  /// Send message
  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      // Insert message
      await _supabase.from('messages').insert({
        'chat_id': chatId,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
        'is_read': false,
      });

      // Update chat's last message
      await _supabase
          .from('chats')
          .update({
            'last_message': message,
            'last_message_time': DateTime.now().toIso8601String(),
          })
          .eq('id', chatId);

      return true;
    } catch (e) {
      _errorMessage = 'Failed to send message: $e';
      notifyListeners();
      return false;
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      await _supabase
          .from('messages')
          .update({'is_read': true})
          .eq('chat_id', chatId)
          .eq('receiver_id', userId)
          .eq('is_read', false);
    } catch (e) {
      _errorMessage = 'Failed to mark messages as read: $e';
    }
  }

  /// Clear messages
  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    unsubscribeFromMessages();
    super.dispose();
  }
}

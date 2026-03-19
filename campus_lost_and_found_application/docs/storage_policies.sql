-- ============================================
-- Storage Bucket Policies
-- Execute AFTER creating the 'item-images' bucket
-- ============================================

-- IMPORTANT: Before running this, you must:
-- 1. Go to Storage in Supabase dashboard
-- 2. Click "Create a new bucket"
-- 3. Name: item-images
-- 4. Public: YES (toggle on)
-- 5. Click "Create bucket"
-- 6. Then run the SQL below

-- ============================================
-- STORAGE POLICIES FOR item-images BUCKET
-- ============================================

-- Policy: Anyone can view item images
CREATE POLICY "Anyone can view item images" ON storage.objects
  FOR SELECT USING (bucket_id = 'item-images');

-- Policy: Authenticated users can upload item images
CREATE POLICY "Authenticated users can upload item images" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'item-images' 
    AND auth.role() = 'authenticated'
  );

-- Policy: Users can update own item images
CREATE POLICY "Users can update own item images" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'item-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Policy: Users can delete own item images
CREATE POLICY "Users can delete own item images" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'item-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- ============================================
-- STORAGE SETUP COMPLETE!
-- ============================================

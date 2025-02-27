Lab 4: Disk Management and Logical Volume Setup

1. Attach a 15GB Disk to the VM and ensure the disk is recognized using:
   
   lsblk
   
2. Create 4 partitions:
   
   ![Image](https://github.com/user-attachments/assets/04c57d72-0ea6-4347-9a72-01033643c0c2)


   ![Image](https://github.com/user-attachments/assets/1777cbc7-03d6-4148-bde1-d2e6be215e55)

3. Format and Mount the 4GB Partition as a file system:

   ![Image](https://github.com/user-attachments/assets/7dad5fb3-9ab4-49b3-bb5d-f1dcfbb67302)

4. Configure the 2GB Partition as Swap :
   
   i'm already configure it while creating the partions

   ![Image](https://github.com/user-attachments/assets/f23d72fe-cd81-4c12-a6ea-8414216a79d1)

   ![Image](https://github.com/user-attachments/assets/238f6617-1e88-448d-a913-c15bff52a871)

5. Set Up LVM :
   
   5.1. Initialize the 6GB Partition as a Physical Volume (PV)

   5.2. Create a Volume Group (VG) with the 6GB PV

   5.3. Create a 5GB Logical Volume (LV)

   5.4. Format and Mount the LV

   ![Image](https://github.com/user-attachments/assets/9ad49ded-b381-4007-9d9c-a97c9e77778b)

6. Extend the Logical Volume with the 3GB Partition

   6.1. Add the Partition to the Volume Group
   
   6.2. Extend the Logical Volume

   ![Image](https://github.com/user-attachments/assets/7d081d77-983f-47df-9f8f-473b5dc83c7e)

7. Verify the Setup

   ![Image](https://github.com/user-attachments/assets/2b571231-7c49-4684-8447-e7f4ead833cd)

   




import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              // Profile card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                        'assets/images/profile_picture.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person_rounded,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                    const SizedBox(height: 14),
                    const Text(
                      'Lil Gui',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'lilgui@binus.ac.id',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Teknik Informatika - 2024',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                        'NIM', '2210511001', Icons.badge_outlined),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                        'Semester', '6', Icons.school_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                        'IPK', '3.75', Icons.star_outline_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                        'SKS', '128', Icons.book_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingsItem(
                  Icons.notifications_outlined, 'Notifikasi', () {}),
              _buildSettingsItem(
                  Icons.lock_outline_rounded, 'Keamanan Akun', () {}),
              _buildSettingsItem(
                  Icons.help_outline_rounded, 'Bantuan & Dukungan', () {}),
              _buildSettingsItem(
                  Icons.info_outline_rounded, 'Tentang Aplikasi', () {}),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout_rounded,
                      color: AppColors.urgent),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(color: AppColors.urgent),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.urgent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'PrioriTask v1.0.0 - MVP',
                  style: TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textHint, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}

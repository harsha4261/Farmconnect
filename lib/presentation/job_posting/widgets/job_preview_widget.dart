import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class JobPreviewWidget extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final Function(int) onEdit;

  const JobPreviewWidget({
    Key? key,
    required this.jobData,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Preview',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This is how your job will appear to workers',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.agriculture,
                        color: AppTheme.onPrimaryLight,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobData['title'] ?? 'Job Title',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jobData['category'] ?? 'Category',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onEdit(0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: AppTheme.primaryLight,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (jobData['description']?.isNotEmpty == true) ...[
                  Text(
                    jobData['description'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppTheme.textSecondaryLight,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      jobData['location'] ?? 'Location',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    const Spacer(),
                    if (jobData['hourlyRate'] != null &&
                        jobData['hourlyRate'] > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight.withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '\$${jobData['hourlyRate']}/hour',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successLight,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildPreviewSection(
            'Requirements',
            [
              if (jobData['experienceLevel']?.isNotEmpty == true)
                'Experience: ${jobData['experienceLevel']}',
              if (jobData['physicalDemands']?.isNotEmpty == true)
                'Physical demands: ${(jobData['physicalDemands'] as List).join(', ')}',
              if (jobData['equipmentFamiliarity']?.isNotEmpty == true)
                'Equipment: ${(jobData['equipmentFamiliarity'] as List).join(', ')}',
              if (jobData['certifications']?.isNotEmpty == true)
                'Certifications: ${(jobData['certifications'] as List).join(', ')}',
            ],
            1,
          ),
          const SizedBox(height: 16),
          _buildPreviewSection(
            'Compensation',
            [
              if (jobData['hourlyRate'] != null && jobData['hourlyRate'] > 0)
                'Hourly Rate: \$${jobData['hourlyRate']}/hour',
              if (jobData['pieceWorkRate'] != null &&
                  jobData['pieceWorkRate'] > 0)
                'Piece Work: \$${jobData['pieceWorkRate']}',
              if (jobData['bonusStructure']?.isNotEmpty == true)
                'Bonus: ${jobData['bonusStructure']}',
              if (jobData['paymentTiming']?.isNotEmpty == true)
                'Payment: ${jobData['paymentTiming']}',
            ],
            2,
          ),
          const SizedBox(height: 16),
          _buildPreviewSection(
            'Schedule',
            [
              if (jobData['scheduleType']?.isNotEmpty == true)
                'Type: ${jobData['scheduleType']}',
              if (jobData['startDate'] != null)
                'Start: ${jobData['startDate'].day}/${jobData['startDate'].month}/${jobData['startDate'].year}',
              if (jobData['endDate'] != null)
                'End: ${jobData['endDate'].day}/${jobData['endDate'].month}/${jobData['endDate'].year}',
              if (jobData['weatherContingency'] == true)
                'Weather contingency applied',
              if (jobData['accommodation'] == true) 'Accommodation provided',
            ],
            3,
          ),
          if (jobData['photos']?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Photos',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                GestureDetector(
                  onTap: () => onEdit(4),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withAlpha(26),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppTheme.primaryLight,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (jobData['photos'] as List).length,
                itemBuilder: (context, index) {
                  final photo = jobData['photos'][index];
                  return Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.dividerLight.withAlpha(77),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        photo,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.dividerLight.withAlpha(77),
                            child: const Icon(
                              Icons.image,
                              size: 24,
                              color: AppTheme.textSecondaryLight,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewSection(
      String title, List<String> items, int sectionIndex) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              GestureDetector(
                onTap: () => onEdit(sectionIndex),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withAlpha(26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppTheme.primaryLight,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $item',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}

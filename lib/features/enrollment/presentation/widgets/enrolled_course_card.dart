// // File: lib/features/enrollment/presentation/widgets/enrolled_course_card.dart
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../data/models/my_course_model.dart';

 

// /// Enrolled Course Card Widget
// class EnrolledCourseCard extends StatelessWidget {
//   final MyCourseModel course;
//   final VoidCallback? onTap;
//   final VoidCallback? onResume;

//   const EnrolledCourseCard({
//     super.key,
//     required this.course,
//     this.onTap,
//     this.onResume,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: onTap,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Thumbnail with status badge
//             _buildThumbnail(context),

//             // Content
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Status badge
//                   _buildStatusBadge(context),

//                   const SizedBox(height: 8),

//                   // Title
//                   Text(
//                     course.title,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),

//                   const SizedBox(height: 8),

//                   // Description
//                   Text(
//                     course.description,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),

//                   const SizedBox(height: 12),

//                   // Progress bar
//                   _buildProgressBar(context),

//                   const SizedBox(height: 12),

//                   // Meta info row
//                   _buildMetaInfo(context),

//                   const SizedBox(height: 12),

//                   // Resume button
//                   if (onResume != null && course.isActive)
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: onResume,
//                         icon: const Icon(Icons.play_arrow, size: 18),
//                         label: const Text('Continue Learning'),
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildThumbnail(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: 160,
//           width: double.infinity,
//           color: Colors.grey[300],
//           child: course.thumbnail != null
//               ? CachedNetworkImage(
//                   imageUrl: course.thumbnail!,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Center(
//                     child: CircularProgressIndicator(
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Center(
//                     child: Icon(
//                       Icons.image_not_supported,
//                       size: 48,
//                       color: Colors.grey[400],
//                     ),
//                   ),
//                 )
//               : Center(
//                   child: Icon(
//                     Icons.school,
//                     size: 48,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//         ),
//         // Status badge
//         Positioned(
//           top: 8,
//           left: 8,
//           child: _buildStatusChip(context),
//         ),
//         // Progress overlay on thumbnail
//         Positioned(
//           bottom: 8,
//           right: 8,
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 8,
//               vertical: 4,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.7),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${course.progressPercentage.toStringAsFixed(0)}%',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusChip(BuildContext context) {
//     Color backgroundColor;
//     Color textColor;
//     String label;

//     switch (course.status) {
//       case 'active':
//         backgroundColor = Colors.green;
//         textColor = Colors.white;
//         label = 'Active';
//         break;
//       case 'completed':
//         backgroundColor = Colors.blue;
//         textColor = Colors.white;
//         label = 'Completed';
//         break;
//       case 'expired':
//         backgroundColor = Colors.red;
//         textColor = Colors.white;
//         label = 'Expired';
//         break;
//       case 'pending':
//         backgroundColor = Colors.orange;
//         textColor = Colors.white;
//         label = 'Pending';
//         break;
//       default:
//         backgroundColor = Colors.grey;
//         textColor = Colors.white;
//         label = course.status;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 4,
//       ),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         label,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusBadge(BuildContext context) {
//     IconData icon;
//     Color color;
//     String text;

//     if (course.isCompleted) {
//       icon = Icons.check_circle;
//       color = Colors.green;
//       text = 'Completed';
//     } else if (course.isActive) {
//       icon = Icons.play_circle;
//       color = Theme.of(context).primaryColor;
//       text = 'In Progress';
//     } else if (course.status == 'expired') {
//       icon = Icons.access_time;
//       color = Colors.red;
//       text = 'Expired';
//     } else {
//       icon = Icons.pending;
//       color = Colors.orange;
//       text = 'Pending';
//     }

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: color),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 color: color,
//                 fontWeight: FontWeight.w500,
//               ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProgressBar(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               course.progressLabel,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: Colors.grey[700],
//                   ),
//             ),
//             Text(
//               '${course.progressPercentage.toStringAsFixed(0)}%',
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: Colors.grey[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: course.progressPercentage / 100,
//           backgroundColor: Colors.grey[300],
//           valueColor: AlwaysStoppedAnimation<Color>(
//             course.isCompleted
//                 ? Colors.green
//                 : Theme.of(context).primaryColor,
//           ),
//           minHeight: 6,
//         ),
//       ],
//     );
//   }

//   Widget _buildMetaInfo(BuildContext context) {
//     return Row(
//       children: [
//         // Lessons count
//         Icon(
//           Icons.play_circle_outline,
//           size: 16,
//           color: Colors.grey[600],
//         ),
//         const SizedBox(width: 4),
//         Text(
//           '${course.completedLessons}/${course.totalLessons} lessons',
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//         const SizedBox(width: 16),

//         // Watch time
//         Icon(
//           Icons.access_time,
//           size: 16,
//           color: Colors.grey[600],
//         ),
//         const SizedBox(width: 4),
//         Text(
//           course.formattedWatchTime,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),

//         const Spacer(),

//         // Enrolled date
//         Icon(
//           Icons.event,
//           size: 16,
//           color: Colors.grey[600],
//         ),
//         const SizedBox(width: 4),
//         Text(
//           '${course.enrolledAt.day}/${course.enrolledAt.month}/${course.enrolledAt.year}',
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ],
//     );
//   }
// }

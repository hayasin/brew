import 'package:careerbrew/services/like_service.dart';
import 'package:careerbrew/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:careerbrew/util/app_colors.dart';

import 'package:careerbrew/models/card_model.dart';
import 'package:uuid/uuid.dart';

class EditCard extends StatefulWidget {
  final CardModel user;
  final String currentUserId;

  const EditCard({super.key, required this.user, required this.currentUserId});

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> with TickerProviderStateMixin {
  final ValueNotifier<Offset> _offsetNotifier = ValueNotifier(Offset.zero);
  final ValueNotifier<Color> _colorNotifier = ValueNotifier(Colors.black);

  //FOCUS NODES
  final FocusNode _taglineFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();

  final ProfileService _profileService = ProfileService();

  String? _lastSavedTagLine;
  String? _lastSavedBio;

  @override
  void initState() {
    super.initState();
    _lastSavedTagLine = widget.user.tagline ?? ''; // Initialize with user data
    _lastSavedBio = widget.user.bio ?? ''; // Initialize with user data

    _taglineFocus.addListener(() async {
      if (!_taglineFocus.hasFocus && _lastSavedTagLine != null) {
        await _profileService.updateUserField(
          userId: widget.currentUserId,
          field: 'tagline',
          value: _lastSavedTagLine,
        );
      }
    });

    _bioFocus.addListener(() async {
      if (!_bioFocus.hasFocus && _lastSavedBio != null) {
        await _profileService.updateUserField(
          userId: widget.currentUserId,
          field: 'bio',
          value: _lastSavedBio,
        );
      }
    });
  }

  bool isExpanded = false;

  @override
  void dispose() {
    _offsetNotifier.dispose();
    _colorNotifier.dispose();
    super.dispose();
  }

  Future<void> _updateSkills() async {
    await _profileService.updateUserField(
      userId: widget.currentUserId,
      field: 'skills',
      value: widget.user.skills,
    );
  }

  Future<void> _updateLookingFor() async {
    await _profileService.updateUserField(
      userId: widget.currentUserId,
      field: 'looking_for',
      value: widget.user.lookingFor,
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final newOffset = _offsetNotifier.value + details.delta;
    _offsetNotifier.value = newOffset;

    if (newOffset.dx < -130) {
      _colorNotifier.value = Colors.red;
    } else if (newOffset.dx > 150) {
      _colorNotifier.value = Colors.green;
    } else {
      _colorNotifier.value = Colors.black;
    }
  }

  Future<void> _swipeCard(double dx) async {
    if (dx.abs() > 150) {
      _resetCardPosition();
    }
  }

  void _resetCardPosition() {
    _offsetNotifier.value = Offset.zero;
    _colorNotifier.value = Colors.black;
  }

  void toggleDetailMode() {
    setState(() {
      isExpanded = !isExpanded;
      if (!isExpanded) _resetCardPosition();
    });
  }

  void _showAddSkillDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add a new skill"),
            content: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: "e.g. Flutter"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final newSkill = _controller.text.trim();
                  if (newSkill.isNotEmpty &&
                      !widget.user.skills.contains(newSkill)) {
                    setState(() {
                      widget.user.skills.add(newSkill);
                    });
                    _updateSkills();
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _showAddLookingFor(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Looking for something else?"),
            content: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "e.g. Capital, Business Ops",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final newSkill = _controller.text.trim();
                  if (newSkill.isNotEmpty &&
                      !widget.user.skills.contains(newSkill)) {
                    setState(() {
                      widget.user.skills.add(newSkill);
                    });
                    _updateLookingFor();
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  @override
  void didUpdateWidget(EditCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width - 20;
    final cardHeight = 340.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Static Card Display
          Center(
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  if (user.mainPicUrl != null)
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: Image.network(
                        user.mainPicUrl!,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.2),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}, ${user.location ?? ''}',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user.tagline != null)
                          Text(
                            user.tagline!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Bottom Sheet Style Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IntrinsicWidth(
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.secondaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '${user.firstName} ${user.lastName}',
                          hintStyle: const TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const Text(
                      ", ",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.secondaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '${user.location}',
                          hintStyle: const TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) => print(value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  focusNode: _taglineFocus,
                  style: const TextStyle(
                    color: AppColors.secondaryPurple,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: '${user.tagline}',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    _lastSavedTagLine = value;
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  "Skills",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children:
                      user.skills
                          .map(
                            (s) => Chip(
                              label: Text(
                                s,
                                style: const TextStyle(color: Colors.white),
                              ),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              backgroundColor: AppColors.secondaryPurple,
                              deleteIconColor: AppColors.accentCoral,
                              onDeleted: () {
                                setState(() {
                                  user.skills.remove(s);
                                });
                                _updateSkills();
                              },
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 6),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    "Add Skill",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.secondaryPurple.withOpacity(0.8),
                  onPressed: () => _showAddSkillDialog(context),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Looking For",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children:
                      user.lookingFor
                          .map(
                            (l) => Chip(
                              label: Text(
                                l,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: AppColors.primaryBlue,
                              deleteIcon: const Icon(Icons.close, size: 18),
                              deleteIconColor: AppColors.accentCoral,
                              onDeleted: () {
                                setState(() {
                                  user.lookingFor.remove(l);
                                });
                                _updateLookingFor();
                              },
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 6),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    "Add More",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.primaryBlue.withOpacity(0.8),
                  onPressed: () => _showAddLookingFor(context),
                ),
                const SizedBox(height: 20),
                const Text(
                  "About Me",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  focusNode: _bioFocus,
                  maxLines: null,
                  onChanged: (value) {
                    _lastSavedBio = value;
                  },
                  style: const TextStyle(
                    color: AppColors.secondaryPurple,
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    hintText: '${user.bio}',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

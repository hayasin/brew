import 'package:careerbrew/services/like_service.dart';
import 'package:flutter/material.dart';
import 'package:careerbrew/models/card_model.dart';
import 'package:uuid/uuid.dart';

class CardView extends StatefulWidget {
  final CardModel user;
  final String currentUserId;
  final void Function(bool isExpanded)? onToggleDetail;
  final bool isTopCard;
  final bool isBlocked;

  const CardView({
    super.key,
    required this.user,
    required this.isTopCard,
    required this.isBlocked,
    required this.currentUserId,
    this.onToggleDetail,
  });

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> with TickerProviderStateMixin {
  final ValueNotifier<Offset> _offsetNotifier = ValueNotifier(Offset.zero);
  final ValueNotifier<Color> _colorNotifier = ValueNotifier(Colors.black);

  bool isVisible = true;
  bool isExpanded = false;

  @override
  void dispose() {
    _offsetNotifier.dispose();
    _colorNotifier.dispose();
    super.dispose();
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
      final isRightSwipe = dx > 0;

      // Call some logic based on swipe direction
      if (isRightSwipe) {
        queryLike(
          likerId: widget.currentUserId,
          likedId: widget.user.id,
        );
      } else {
        dislikeService(userA: widget.currentUserId, userB: widget.user.id);
        print('👎 Swiped left – disliked');
        // You could call your dislike or skip logic here
      }

      _offsetNotifier.value = Offset(isRightSwipe ? 500 : -500, 0);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            isVisible = false;
          });
        }
      });
    } else {
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

    widget.onToggleDetail?.call(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBlocked || !isVisible) return const SizedBox.shrink();

    final user = widget.user;
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = isExpanded ? screenSize.width - 20 : 360.0;
    final cardHeight = isExpanded ? 340.0 : 420.0;
    final topPosition = isExpanded ? 10.0 : screenSize.height * 0.18;

    return Stack(
      children: [
        // Main Card
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          top: topPosition,
          left: (screenSize.width - cardWidth) / 2,
          child: AnimatedBuilder(
            animation: Listenable.merge([_offsetNotifier, _colorNotifier]),
            builder: (context, _) {
              return GestureDetector(
                onPanUpdate: isExpanded ? null : _handleDragUpdate,
                onPanEnd:
                    isExpanded
                        ? null
                        : (details) {
                          if (_offsetNotifier.value.dy < -50) {
                            toggleDetailMode();
                          } else {
                            _swipeCard(_offsetNotifier.value.dx);
                          }
                        },
                child: Transform.translate(
                  offset: isExpanded ? Offset.zero : _offsetNotifier.value,
                  child: Transform.rotate(
                    angle:
                        isExpanded
                            ? 0
                            : _offsetNotifier.value.dx / 40 * 0.0174533,
                    child: Material(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          // Background Image (Hero)
                          if (user.mainPicUrl != null)
                            Hero(
                              tag: 'user-image-${user.id}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  width: cardWidth,
                                  height: cardHeight,
                                  child: Image.network(
                                    user.mainPicUrl!,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    color: Colors.black.withOpacity(0.2),
                                    colorBlendMode: BlendMode.darken,
                                  ),
                                ),
                              ),
                            ),

                          // Overlay Content
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn,
                            width: cardWidth,
                            height: cardHeight,
                            padding: EdgeInsets.all(isExpanded ? 0 : 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _colorNotifier.value.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset.zero,
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child:
                                  !isExpanded
                                      ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${user.firstName} ${user.lastName}, ${user.location ?? ''}",
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (user.tagline != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              child: Text(
                                                user.tagline!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom Sheet
        if (isExpanded)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 5) toggleDetailMode();
              },
              child: Container(
                height: screenSize.height - cardHeight - 20,
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        "${user.firstName} ${user.lastName}, ${user.location ?? ''}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (user.tagline != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(user.tagline!),
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
                                .map((s) => Chip(label: Text(s)))
                                .toList(),
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
                                .map((l) => Chip(label: Text(l)))
                                .toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "About Me",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(user.bio ?? "No bio yet."),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

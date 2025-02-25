import 'package:flutter/material.dart';

class AddToMyListButton extends StatefulWidget {
  final VoidCallback?
      onComplete; // Animasyon tamamlandığında çağrılacak bir callback

  const AddToMyListButton({super.key, this.onComplete});

  @override
  _AddToMyListButtonState createState() => _AddToMyListButtonState();
}

class _AddToMyListButtonState extends State<AddToMyListButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAdded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 1), () {
            _controller.reverse().then((_) {
              setState(() {
                _isAdded = false;
              });
            });
          });
        }
      });
  }

  void _onPressed() {
    if (!_isAdded) {
      _controller.forward().then((_) {
        setState(() {
          _isAdded = true;
        });
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_animation.value, 0),
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: _isAdded ? Colors.green : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      _isAdded ? 'Listeme eklendi  !' : 'FilmList Ekle',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

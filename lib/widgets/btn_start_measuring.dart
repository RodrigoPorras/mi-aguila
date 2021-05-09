part of 'widgets.dart';

class BtnStartMeasuring extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  const BtnStartMeasuring({Key key, this.onPressed, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
            icon,
            color: Colors.black87,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

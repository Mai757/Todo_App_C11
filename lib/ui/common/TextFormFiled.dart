import 'package:flutter/material.dart';

typedef Validator = String? Function (String? text);
class AppFormFiled extends StatefulWidget {
  String title;
  String hint;
  TextInputType keyboardType ;
  bool securedPassword;
  Validator? validator= null;
  TextEditingController? controller = null;
  AppFormFiled({required this.title,required this.hint,
    this.keyboardType = TextInputType.text,
    this.securedPassword = false,
    this.validator,
    this.controller});

  @override
  State<AppFormFiled> createState() => _AppFormFiledState();
}

class _AppFormFiledState extends State<AppFormFiled> {
  bool isVisibleText = true;
  @override
  void initState() {
    super.initState();
    isVisibleText = widget.securedPassword;
  }
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,
            style: Theme.of(context).textTheme.titleSmall,),
          SizedBox(height: 12,),
          TextFormField(
            validator: widget.validator,
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: Colors.red,fontSize: 16
              ),
              suffixIcon: widget.securedPassword? InkWell(
                onTap: (){
                  setState(() {
                    isVisibleText = !isVisibleText;

                  });
                },
                child: Icon(
                    isVisibleText?
                    Icons.visibility_off_outlined:
                    Icons.visibility
                ),
              )
                  :null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black
              ),
            ),
            keyboardType: widget.keyboardType,
            obscureText: isVisibleText,
            controller: widget.controller,


          ),

        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../models/Details/taskDetailMode.dart';
import '../models/imageGetModel.dart';

class taskDetailScreen extends StatefulWidget {
  final int id;
   taskDetailScreen({required Key key,required this.id}) : super(key: key);

  @override
  State<taskDetailScreen> createState() => _taskDetailScreenState();
}

class _taskDetailScreenState extends State<taskDetailScreen> {
  final String formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

   XFile? imageFile;
  XFile? imageFile1;

  void _openGallery(BuildContext context) async{
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery ,
    );
    if(imageFile==null){
      setState(() {
        imageFile = pickedFile!;
      });}else{
      setState(() {
        imageFile1 = pickedFile;
      });}

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context)  async{

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera ,
    );
    if(imageFile==null){
      setState(() {
        imageFile = pickedFile;
      });}else{
      setState(() {
        imageFile1 = pickedFile;
      });}
    Navigator.pop(context);
  }
  Future<void>_showChoiceDialog(BuildContext context)
  {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title:  Text("Choose option",style: TextStyle(
            color: blkTxtClr),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.black),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: appClr),
              ),

              Divider(height: 1,color:  blkTxtClr,),
              ListTile(
                onTap: (){
                  _openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: appClr),
              ),
            ],
          ),
        ),);
    });
  }
  List<String> textcomment = [];
  showAlertDialog(BuildContext context) {
    // Create button
    Widget submitButton = Container(
      padding:const EdgeInsets.only(left: 7,right: 7),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/16,
      child: ElevatedButton(
        onPressed: () async{
          setState(() {
            if(_controller.text.length>0){
              textcomment.add(_controller.text.toString());
             // _controller.clear();
            } else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Text is empty"),
              ));
            }
          });
          commentPost(widget.id,_controller.text);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content:Text("Comment added Successfully")));
          //_controller.text;
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: appClr, // background
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14))
            )// foreground
        ),
        child: const Text("Submit"),
      ),
    );

    AlertDialog alert = AlertDialog(
      titlePadding:const EdgeInsets.only(left: 15,right: 5,top: 5),
      contentPadding:const EdgeInsets.only(left: 15,right: 15,top: 10),
        actionsPadding:const EdgeInsets.only(top: 10,bottom: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)
      ),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Reply",style: blk16txtStyle,),
          IconButton(onPressed: (){},
              icon:const Icon(MdiIcons.closeBox,color: Colors.grey,))
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Your comment",style: blk13txtStyle,),
            topPadding8,
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: (){
                  _controller.clear();
                }, icon:const Icon(Icons.clear)),
                  border: OutlineInputBorder(
                    borderSide:const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                hintText: 'Type your comment',
                fillColor: txtfieldFilledclr,
                filled: true
              )
            )
          ],
        ),
      ),
      actions: [
        submitButton,],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  var taskDetailsList = TaskDetailModel();

  Future postImage(imageType) async {
    var requestBody = {
      'image':base64string,
      'imageType':imageType,
      'photos_source':'http',
      'type':'.jpg',
    };
    return await http.post(
      Uri.parse('${baseUrl}task/uploadbeforeimage?taskid=${widget.id}'),
      body: requestBody,
        headers: {
          // 'Content-type': 'application/json',
          // 'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) => {
      setState((){
        print('image uplocaded successfullyy');
        print(response.body);
        var jsonResponse = json.decode(response.body);
        imageGet =  ImageGetModel.fromJson(jsonResponse);
        print('image get');
        print(imageGet.uploaded_image);
      })
    });
  }


  final ImagePicker imgpicker = ImagePicker();
  String imagepathBefore = "";
  String imagepathAfter = "";
  String base64string='';
  var imageGet = ImageGetModel();
  openImageBefore() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if(pickedFile != null){
        imagepathBefore = pickedFile.path;
        print(imagepathBefore);
        File imagefile = File(imagepathBefore); //convert Path to File
        Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
         base64string = base64.encode(imagebytes); //convert bytes to base64 string
        print('ok je');
        print(base64string);
        Uint8List decodedbytes = base64.decode(base64string);
        await postImage('before');
        await ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Image Uploaded Successfully"),
            ));
        setState(() {
          //  postTest('before');
          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(
          //       behavior: SnackBarBehavior.floating,
          //       content: Text("Image Uploaded Successfully"),
          //     ));
        });
      }else{
        print("No image is selected.");
      }
    }catch (e) {
      print("error while picking file.");
    }
  }
  openImageAfter() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if(pickedFile != null){
        imagepathAfter = pickedFile.path;
        print(imagepathAfter);
        File imagefile = File(imagepathAfter); //convert Path to File
        Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
        base64string = base64.encode(imagebytes); //convert bytes to base64 string
        print('ok je');
        print(base64string);
        Uint8List decodedbytes = base64.decode(base64string);
        await postImage('after');
        await ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Image Uploaded Successfully"),
            ));
        setState(() {
          //  postTest('before');
          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(
          //       behavior: SnackBarBehavior.floating,
          //       content: Text("Image Uploaded Successfully"),
          //     ));
        });
      }else{
        print("No image is selected.");
      }
    }catch (e) {
      print("error while picking file.");
    }
  }
  final GlobalKey<FormState> _formKey =  GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  Future loadTaskDetail() async {
    return await http.post(Uri.parse('${baseUrl}task/viewdetail?id=${widget.id}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${BearerToken}'
        }
    ).then((response) =>
    {
      setState(() {
        var jsonResponse = json.decode(response.body);
        taskDetailsList =  TaskDetailModel.fromJson(jsonResponse);
      })
    });
  }


  Future commentPost(id,controller) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${BearerToken}'
    };
    var UpdateCommentPostObject = taskDetailsList.toJson();
    var userBody = json.encode(UpdateCommentPostObject);

    var res = await http.post(
      Uri.parse (
          '${baseUrl}task/storeTaskComment?task_id=$id&comment=$controller' ),
      headers: header, body: userBody,);
    print('status code');
    print(res.statusCode);
    return res.statusCode;
  }
  @override
  Widget build(BuildContext context) {
     loadTaskDetail().whenComplete(() => setState((){}));
     //commentPost(widget.id,_controller.text).whenComplete(() => setState((){}));
    // var document = parse(
    //     taskDetailsList.task!.post);
     return Scaffold(
      backgroundColor: whiteTxtClr,
      appBar: PreferredSize(
          preferredSize:const Size.fromHeight(80),
          child: AppBar(
            leading:  Padding(
              padding:  EdgeInsets.only(top: 10,left: 8),
              child: Container(
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: IconButton(
                  icon: Icon(Icons.menu),
                  tooltip: 'Setting Icon',
                  onPressed: () {},
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset('assets/Frame.png'))
            ),
            centerTitle: true,
            backgroundColor: appClr,
            title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text('Task Name',style: apptitle,),
            ) ,
          )
      ),
      body:
          taskDetailsList==null||taskDetailsList==''||
      taskDetailsList.task==null||taskDetailsList.task==''
        ||taskDetailsList.task!.comments!.isEmpty
          ? Container(
          height: double.infinity,
          width: double.infinity,
          color: whiteTxtClr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Container(child: Text('Loading... Please wait',style: TextStyle(
                  color: whiteTxtClr
              ),),),
              const CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: appClr,
              )
            ],
          )
      )
            :
      Stack(
        children: [
          ListView(
            padding:const EdgeInsets.only(left: 15,right: 15,top: 15),
            children: [
              Row(
               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        taskDetailsList.task!.title.toString(),
                        style: blk16txtStyle
                      ),
                      topPadding6,
                      Row(
                        children: [
                          const Icon(Icons.person_outline,size: 15,),
                          widthPadding6,
                          Text(taskDetailsList.task!.user.toString(),style: blk13txtStyle),
                          widthPadding50,widthPadding20,
                          Row(
                            children: [
                              SvgPicture.asset('assets/calendar.svg',
                                color: Colors.grey,
                                height: 15,
                              ),
                              widthPadding6,
                              Text(taskDetailsList.task!.accepted!.substring(0,10).toString()),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],),
              topPadding8,
              Text( taskDetailsList.task!.post.toString().replaceAll(exp, ''),style: grey13txtStyle,),
              topPadding14,
              Row(
                children: [
                (  imagepathBefore == ""||imagepathBefore==null)?
                Expanded(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius:const Radius.circular(12),
                    color: appClr,
                    strokeWidth: 2, //thickness of dash/dots
                    dashPattern: const [10,3],
                    child: GestureDetector(
                      onTap: (){
                        openImageBefore();
                        //_showChoiceDialog(context);
                        //postTest();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: appClr.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.height/5,
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/addimage.svg'),
                                  topPadding6,
                                  Text('Tap to Upload',style: appclr16txtStyle,),
                                  topPadding6,
                                  Text('Upload the before picture',style: greytxtStyle,),
                                ],
                              )
                          )
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:Image.file(File(imagepathBefore))),
                ),
                widthPadding14,
                ( imagepathAfter == ""||imagepathAfter==null)?
                Expanded(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius:const Radius.circular(12),
                    color: appClr,
                    strokeWidth: 2, //thickness of dash/dots
                    dashPattern: const [10,3],
                    child: GestureDetector(
                      onTap: (){
                        openImageAfter();
                        //_showChoiceDialog(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: appClr.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.height/5,
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    SvgPicture.asset('assets/addimage.svg'),

                                  topPadding6,
                                  Text('Tap to Upload',style: appclr16txtStyle,),
                                  topPadding6,
                                  Text('Upload the after picture',style: greytxtStyle,),
                                ],
                              )
                          )
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child:  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:Image.file(File(imagepathAfter)),
                  ),
                ),
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                ( imagepathBefore!=null||imagepathBefore!='')?TextButton.icon(
                  label: Text('Before',style: TextStyle(color: Colors.black,),),
                  icon: Icon(FontAwesomeIcons.penToSquare,color: Colors.black,),
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                ):Container(),
                (imagepathAfter!=null||imagepathAfter!='')?TextButton.icon(
                  icon: Icon(FontAwesomeIcons.penToSquare,color: Colors.black,),
                  label: Text('After',style: TextStyle(color: Colors.black,),),
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                ):Container()
              ],),
              topPadding20,
              Text(
                'Replies',
                style: blk20txtStyle,
              ),  topPadding10,
              taskDetailsList.task!.comments!.isEmpty?
                Container():
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(14)
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,bottom: 8,top: 8,right:250),
                      child:
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        primary: false,
                        shrinkWrap: true,
                        itemCount: taskDetailsList.task!.comments!.length,
                        itemBuilder: (context, i) {
                          DateTime parseData = DateFormat('yyyy-MM-ddTHH:mm:ss.000000Z')
                              .parse(taskDetailsList.task!.comments![i].dated.toString());
                          var inputDate = DateTime.parse(parseData.toString());
                          var outPutFormat = DateFormat.jm();
                          var outputDate = outPutFormat.format(inputDate);
                          return ListView(
                            shrinkWrap: true,
                            primary: false,
                            scrollDirection: Axis.vertical,
                            children: [
                              Card(
                                  shape:const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15)
                                      ) ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(taskDetailsList.task!.comments![i].comment.toString()),
                                  )),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(outputDate)),
                            ],
                          );
                        },)
                    ),
                  ),
              //Text(base64string),
             const SizedBox(height: 80,),
            ],
          ),
          Positioned(
            bottom: 5,
            child: Container(
              padding:const EdgeInsets.only(left: 15,right: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/16,
              child: ElevatedButton(
                onPressed: () async{
                  showAlertDialog(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: appClr, // background
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14))
                    )// foreground
                ),
                child: const Text("Send Reply"),
              ),
            ),
          ),
        ],
      )
    );
  }
}

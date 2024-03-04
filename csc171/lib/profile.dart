import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'isarModels/userProfile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isDarkMode = true;
  late Isar isar;
  late File _image = File('');
  bool _imageLoading = false;

  void initState() {
    super.initState();
    initIsar();
  }

  Future<void> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [UserProfileSchema],
      directory: dir.path,
    );
    print(isar);
    final userProfileList = await isar.userProfiles.where().findAll();
    if (userProfileList.isNotEmpty) {
      userProfileList.sort((a, b) => b.id.compareTo(a.id));
      final userProfile = userProfileList.first;

      setState(() {
        _image = File(userProfile.imagePath);
      });
    }

    getDarkMode();
  }

  Future<void> saveImagePathToIsar(String imagePath) async {
    final userProfile = UserProfile()..imagePath = imagePath;
    await isar.writeTxn(() async {
      await isar.userProfiles.put(userProfile);
    });
  }

  Future<void> _getImage(ImageSource source) async {
    setState(() {
      _imageLoading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      _imageLoading = false;
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        saveImagePathToIsar(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> getDarkMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = preferences.getBool("isDarkMode") ?? true;
    });
  }

  void setDarkMode(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("isDarkMode", value);
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Select Image Source'),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _getImage(ImageSource.gallery);
                          },
                          child: const Text('Gallery'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _getImage(ImageSource.camera);
                          },
                          child: const Text('Camera'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: _imageLoading
                  ? const CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          // ignore: unnecessary_null_comparison
                          _image != null ? FileImage(_image) : null,
                      // ignore: unnecessary_null_comparison
                      child: _image == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                            )
                          : null,
                    ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Profile Page Content',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Dark Mode?',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  Switch(
                    value: isDarkMode,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (value) => setDarkMode(value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

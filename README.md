# drawper

Semester project for CIS*4030 Mobile Computing, by Michelle Berry, Austin Van Braeckel, and Arnab Sagar.

## Description
This is a social media app where you are prompted to post one drawing/doodle per day. You are given a prompt every day, and you have to post a drawing to be able to view other people's drawings. 
The goals this app accomplishes is encouraging creativity while discouraging mindless doom scrolling. It is also a good tool for those who want to improve their drawing skills in a casual way (the drawps are not expected to be overly polished/perfect, so it is a low pressure environment). 

## Running Locally
Prerequisites: 
- install android studio
- install dart
- install vscode + flutter extension

Steps:
1. Clone repo
2. flutter pub get (download dependencies)
3. Create emulator on android studio > virtual device manager. We used the oldest android version because the VD was so slow on our laptops. Specs of mine are: android 7.0 nougat, Pixel 3A
4. In vscode, connect the emulator in the bottom right corner, and used vscode UI to run the app (from the top right corner while on lib/main.dart).

## Development Status / Future Goals
This app is unfinished,

So far we have implemented:
- drawing functionality
- create account / sign in functionality (via firebase)
- ability to post a drawing, view other's drawings in feed, search other users (this will need work for production version), view your account & edit, and view other users accounts

Want to still implement (is mocked in current implementation):
- ability to like/dislike
- points system
- better security for accounts, ie 2 factor authentication, and having to confirm account via email
- rotating daily prompt system

Then we would like to put it into app stores

   

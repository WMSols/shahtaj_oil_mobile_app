import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Semantic Iconsax icon mappings used across the app.
///
/// Outline icons use default Iconsax names. Filled (bulk) variants append `5`
/// per Iconsax convention — e.g. [dashboard] / [dashboard5].
class AppIcons {
  AppIcons._();

  // Navigation
  static const IconData menu = Icons.menu_rounded;
  static const IconData dashboard = Iconsax.home_2;
  static const IconData dashboard5 = Iconsax.home_25;

  static const IconData routes = Iconsax.map;
  static const IconData routes5 = Iconsax.map5;

  static const IconData shops = Iconsax.shop;
  static const IconData shops5 = Iconsax.shop5;
  static const IconData addshop = Iconsax.shop_add;
  static const IconData addshop5 = Iconsax.shop_add5;
  static const IconData myshops = Iconsax.shopping_cart;
  static const IconData myshops5 = Iconsax.shopping_cart5;

  static const IconData history = Iconsax.note_2;
  static const IconData history5 = Iconsax.note_25;

  static const IconData account = Iconsax.profile_tick;
  static const IconData account5 = Iconsax.profile_tick5;

  static const IconData invoices = Iconsax.receipt;
  static const IconData invoices5 = Iconsax.receipt5;

  static const IconData deliveries = Iconsax.document_text;
  static const IconData deliveries5 = Iconsax.document_text5;

  static const IconData collections = Iconsax.receipt;
  static const IconData collections5 = Iconsax.receipt5;

  static const IconData handover = Iconsax.document_upload;
  static const IconData handover5 = Iconsax.document_upload5;

  // Actions
  static const IconData back = Iconsax.arrow_left_2;
  static const IconData back5 = Iconsax.arrow_left_25;
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  static const IconData view = Iconsax.eye;
  static const IconData view5 = Iconsax.eye4;

  static const IconData task = Iconsax.task_square;
  static const IconData task5 = Iconsax.task_square5;

  static const IconData checkCircle = Iconsax.tick_circle;
  static const IconData checkCircle5 = Iconsax.tick_circle5;

  static const IconData download = Icons.download;
  static const IconData delete = Iconsax.trash;
  static const IconData delete5 = Iconsax.trash5;

  static const IconData search = Icons.search;
  static const IconData notification = Iconsax.notification;
  static const IconData notification5 = Iconsax.notification5;

  static const IconData arrowDown = Iconsax.arrow_down_1;
  static const IconData arrowUp = Iconsax.arrow_up_2;

  static const IconData block = Iconsax.forbidden_2;
  static const IconData block5 = Iconsax.forbidden_25;

  static const IconData empty = Iconsax.emoji_sad;
  static const IconData empty5 = Iconsax.emoji_sad5;

  // Auth & profile
  static const IconData email = Iconsax.sms;
  static const IconData email5 = Iconsax.sms5;

  static const IconData person = Iconsax.profile_tick;
  static const IconData person5 = Iconsax.profile_tick5;

  static const IconData personalCard = Iconsax.personalcard;
  static const IconData personalCard5 = Iconsax.personalcard5;

  static const IconData lock = Iconsax.lock;
  static const IconData lock5 = Iconsax.lock5;

  static const IconData eye = Iconsax.eye;
  static const IconData eye5 = Iconsax.eye4;

  static const IconData eyeSlash = Iconsax.eye_slash;
  static const IconData eyeSlash5 = Iconsax.eye_slash5;

  static const IconData sms = Iconsax.sms;
  static const IconData sms5 = Iconsax.sms5;

  // Communication
  static const IconData phone = Iconsax.call;
  static const IconData phone5 = Iconsax.call5;

  static const IconData chat = Iconsax.messages;
  static const IconData chat5 = Iconsax.messages5;

  // Form & media
  static const IconData calendar = Iconsax.calendar;
  static const IconData calendar5 = Iconsax.calendar5;

  static const IconData upload = Iconsax.document_upload;
  static const IconData upload5 = Iconsax.document_upload5;

  static const IconData document = Iconsax.document_text;
  static const IconData document5 = Iconsax.document_text5;

  static const IconData image = Iconsax.gallery;
  static const IconData image5 = Iconsax.gallery5;

  static const IconData inbox = Iconsax.direct_inbox;
  static const IconData inbox5 = Iconsax.direct_inbox5;

  static const IconData location = Iconsax.location;
  static const IconData location5 = Iconsax.location5;

  static const IconData locationPin = Icons.location_on;

  static const IconData map = Iconsax.map;
  static const IconData map5 = Iconsax.map5;

  static const IconData grid = Iconsax.element_3;
  static const IconData grid5 = Iconsax.element_35;

  static const IconData expand = Iconsax.maximize_4;
  static const IconData expand5 = Iconsax.maximize_45;

  static const IconData question = Iconsax.message_question;
  static const IconData question5 = Iconsax.message_question5;

  static const IconData wallet = Iconsax.wallet;
  static const IconData wallet5 = Iconsax.wallet5;

  static const IconData cloudUpload = Iconsax.cloud_add;
  static const IconData cloudUpload5 = Iconsax.cloud_add5;

  static const IconData gps = Iconsax.gps;
  static const IconData gps5 = Iconsax.gps5;

  static const IconData userAdd = Iconsax.user_add;
  static const IconData userAdd5 = Iconsax.user_add5;

  static const IconData cameraAdd = Iconsax.camera;
  static const IconData cameraAdd5 = Iconsax.camera5;

  static const IconData gallery = Iconsax.gallery_add;
  static const IconData gallery5 = Iconsax.gallery_add5;

  /// Returns the filled variant when [active] is true, otherwise [icon].
  static IconData filled(IconData icon, {bool active = true}) {
    if (!active) return icon;

    return switch (icon) {
      dashboard => dashboard5,
      routes => routes5,
      shops => shops5,
      addshop => addshop5,
      myshops => myshops5,
      history => history5,
      account || person => account5,
      invoices || collections => invoices5,
      deliveries || document => deliveries5,
      handover || upload => handover5,
      back => back5,
      view || eye => view5,
      task => task5,
      checkCircle => checkCircle5,
      delete => delete5,
      notification => notification5,
      email || sms => email5,
      personalCard => personalCard5,
      lock => lock5,
      eyeSlash => eyeSlash5,
      phone => phone5,
      chat => chat5,
      calendar => calendar5,
      image => image5,
      inbox => inbox5,
      location => location5,
      map => map5,
      grid => grid5,
      expand => expand5,
      question => question5,
      wallet => wallet5,
      cloudUpload => cloudUpload5,
      gps => gps5,
      userAdd => userAdd5,
      cameraAdd => cameraAdd5,
      gallery => gallery5,
      block => block5,
      empty => empty5,
      _ => icon,
    };
  }
}

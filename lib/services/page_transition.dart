import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/components/suggest_user_dialog.dart';
import 'package:flutter_cafclcc/models/match_item.dart';
import 'package:flutter_cafclcc/models/user_suggest.dart';
import 'package:flutter_cafclcc/screens/match_details/match_details.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/constants.dart' as constants;

class PageTransition {

  BuildContext context;

  AdmobInterstitial interstitialAd;
  MaterialPageRoute materialPageRoute;
  bool pushReplacement = false, showAdmobInterstitial = false;
  ProgressDialog progressDialog;

  PageTransition (this.context, this.materialPageRoute, this.pushReplacement);

  //check if app can suggest user to share or rate application
  Future checkForRateAndShareSuggestion() async {
    progressDialog = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    interstitialAd = AdmobInterstitial(
      adUnitId: constants.getAdmobInterstitialId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) async {
        progressDialog.hide();
        if(event == AdmobAdEvent.loaded) {
          interstitialAd.show();
        }
        else if(event == AdmobAdEvent.closed || event == AdmobAdEvent.failedToLoad) {
          if(!pushReplacement) {
            Navigator.push(context, materialPageRoute);
          }
          else {
            Navigator.pushReplacement(context, materialPageRoute);
          }
        }
      },
    );

    int pageNumber = await getTransitionNumber();
    if(pageNumber == null) {
      pageNumber = 0;
    }
    int newPageNumber = pageNumber + 1;
    if(newPageNumber > 10) {
      newPageNumber = 0;
    }
    setTransitionNumber(newPageNumber);
    if(pageNumber > 0 && pageNumber % 6 == 0) {
      if(constants.canShowAds) {
        progressDialog.show();
        if(showAdmobInterstitial) {
          loadAdmobInterstitial();
        }
        else {
          FacebookInterstitialAd.loadInterstitialAd(
            placementId: constants.FACEBOOK_AD_INTERSTITIAL_ID,
            listener: (result, value) {
              switch (result) {
                case InterstitialAdResult.ERROR:
                  loadAdmobInterstitial();
                  if(!pushReplacement) {
                    Navigator.push(context, materialPageRoute);
                  }
                  else {
                    Navigator.pushReplacement(context, materialPageRoute);
                  }
                  break;
                case InterstitialAdResult.LOADED:
                  FacebookInterstitialAd.showInterstitialAd(delay: 5000);
                  break;
                case InterstitialAdResult.CLICKED:
                  FacebookInterstitialAd.destroyInterstitialAd();
                  if(!pushReplacement) {
                    Navigator.push(context, materialPageRoute);
                  }
                  else {
                    Navigator.pushReplacement(context, materialPageRoute);
                  }
                  break;
                case InterstitialAdResult.LOGGING_IMPRESSION:
                  break;
                case InterstitialAdResult.DISMISSED:
                  if(!pushReplacement) {
                    Navigator.push(context, materialPageRoute);
                  }
                  else {
                    Navigator.pushReplacement(context, materialPageRoute);
                  }
                  break;
                case InterstitialAdResult.DISPLAYED:
                  progressDialog.hide();
                  break;
              }
            },
          );
        }
      }
    }
    else if(pageNumber > 0 && pageNumber % 10 == 0) {
      UserSuggest userSuggest = await UserSuggest.getSuggestUserDetails();
      bool canSuggest = false;
      SuggestType sType;
      if (userSuggest.lastSuggestion == UserSuggest.SUGGESTION_SHARE) {
        canSuggest = true;
        if (userSuggest.canSuggestRate) {
          sType = SuggestType.SUGGEST_RATE_APP;
        }
        else if (userSuggest.canSuggestShare) {
          sType = SuggestType.SUGGEST_SHARE_APP;
        }
        else {
          canSuggest = false;
        }
      }
      else if (userSuggest.lastSuggestion == UserSuggest.SUGGESTION_RATE) {
        canSuggest = true;
        if (userSuggest.canSuggestShare) {
          sType = SuggestType.SUGGEST_SHARE_APP;
        }
        else if (userSuggest.canSuggestRate) {
          sType = SuggestType.SUGGEST_RATE_APP;
        }
        else {
          canSuggest = false;
        }
      }
      if (canSuggest) {
        await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return SuggestUserDialog(sType, userSuggest);
              }).then((value) {
          if(!pushReplacement) {
            Navigator.push(context, materialPageRoute);
          }
          else {
            Navigator.pushReplacement(context, materialPageRoute);
          }
        });
      }
    }
    else {
      if(!pushReplacement) {
        Navigator.push(context, materialPageRoute);
      }
      else {
        Navigator.pushReplacement(context, materialPageRoute);
      }
    }
  }

  Future loadAdmobInterstitial() async {
    await interstitialAd.load();
  }

  Future<int> getTransitionNumber() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int transitionNumber = sharedPreferences.getInt('transition_number');

    return transitionNumber;

  }

  Future setTransitionNumber(int transitionNumber) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('transition_number', transitionNumber);

  }

}
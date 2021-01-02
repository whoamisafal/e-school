import 'package:admob_flutter/admob_flutter.dart';

String getAppId() => "ca-app-pub-9571766420568996~7369807680";
String getBannerId() => "ca-app-pub-9571766420568996/3869546370";
String getInterstialId() => "ca-app-pub-9571766420568996/1035677087";
String getBannerId2() => "ca-app-pub-9571766420568996/9440330037";
String getNativeId()=>"ca-app-pub-9571766420568996/2523377942";
String getRewardId()=>"ca-app-pub-9571766420568996/1706417463";
void hadleEvent(AdmobAdEvent event, Map<String, dynamic> arg, String type) {
  switch (event) {
    case AdmobAdEvent.loaded:
      print('$type ad loaded!');
      break;
    case AdmobAdEvent.opened:
      print('$type ad open!');
      break;
    case AdmobAdEvent.closed:
      print('$type ad closed!');
      break;
    case AdmobAdEvent.failedToLoad:
      print('$type failed to load!');
      break;
    case AdmobAdEvent.rewarded:
      print('you are rewarded!');
      break;
    default:
  }
}

AdmobInterstitial initInterstitial(AdmobInterstitial interstitial) {
  return AdmobInterstitial(
    adUnitId: getInterstialId(),
    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      if (event == AdmobAdEvent.closed) interstitial.load();
      hadleEvent(event, args, 'Interstitial');
    },
  );
}

AdmobReward initReward(AdmobReward reward)
{
  return AdmobReward(adUnitId: getRewardId(),listener: (AdmobAdEvent event,Map<String,dynamic> args) {
    if(event==AdmobAdEvent.closed)reward.load();
    hadleEvent(event, args, "Reward");
  } ,);
}

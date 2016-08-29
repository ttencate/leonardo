package;

import flixel.FlxG;

class Url {

  public static function base(): String {
#if html5
    var url = "" + js.Browser.window.location;
    var hashIndex = url.indexOf("#");
    if (hashIndex >= 0) {
      return url.substring(0, hashIndex);
    } else {
      return url;
    }
#else
    return "/";
#end
  }

  public static function hash(): String {
#if html5
    var hash = js.Browser.window.location.hash;
    if (hash == "") {
      return "";
    } else {
      return hash.substring(1);
    }
#else
    return "";
#end
  }

  public static function setLocation(location: String) {
#if html5
    js.Browser.window.location.href = location;
#else
    trace("Would set location to:", location);
#end
  }

  public static function uploadSolution(puzzleName: String, programUrl: String, holeCount: Int, cycleCount: Int) {
    var uid = getUid();
#if html5
    untyped window.uploadSolution(uid, puzzleName, programUrl, holeCount, cycleCount);
#else
    trace("Would upload solution:", uid, puzzleName, programUrl, holeCount, cycleCount);
#end
  }

  private static function getUid() {
    var uid = FlxG.save.data.uid;
    if (uid == null) {
      uid = Date.now().getTime() + "-" + FlxG.random.int();
      FlxG.save.data.uid = uid;
      FlxG.save.flush();
    }
    return uid;
  }
}

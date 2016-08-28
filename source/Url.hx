package;

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
#end
  }
}

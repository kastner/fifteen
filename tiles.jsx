var theDoc = activeDocument;
var docWidth = theDoc.width.value;
var docHeight = theDoc.height.value;
var opts = new PNGSaveOptions();

var black = new SolidColor();
black.rgb.red = black.rgb.green = black.rgb.blue = 0;

var white = new SolidColor();
white.rgb.red = white.rgb.green = white.rgb.blue = 255;

theDoc.layers["Text"].visible = true;

for(i=1; i<=15; i++) {
  theDoc.layers["Text"].textItem.contents = i;
  if (i % 2 == 0) {
    theDoc.layers["Red"].visible = false;
    theDoc.layers["Text"].textItem.color = black;
  }
  else {
    theDoc.layers["Red"].visible = true;
    theDoc.layers["Text"].textItem.color = white;
  }
  
  saveFile = new File("/Users/kastner/Development/iPhone/15/skel/tile" + i + ".png");
  
  theDoc.saveAs(saveFile, opts, true, Extension.LOWERCASE);
}
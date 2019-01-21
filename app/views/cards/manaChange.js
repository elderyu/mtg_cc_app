"use strict"
document.addEventListener("DOMContentLoaded", function(e) {
  var manaString = document.getElementsByClassName("mana");
  var length = manaString.length;
  var i;
  for(i=0; i<length; i++){
    var textText = manaString[i].innerHTML;
    var mana = "";
    var meltingText = textText;
    var foundMana;
    var foundManaAt = 1;
    var manaSymbol;
    var foundManaTrimmed;
    var newText = textText;
    while(foundManaAt > 0){
      foundManaAt = meltingText.search(/{([BWUGRCT\d]+\/*)+}/i);
      if(foundManaAt < 0 ) break;
      var end = meltingText.search(/}/);
      foundMana = meltingText.slice(foundManaAt,end+1);
      meltingText = meltingText.slice(end+1);
      foundManaTrimmed = foundMana.slice(1,-1);
      manaSymbol = foundManaTrimmed;
      newText = newText.replace(foundMana,addManaImgURL(manaSymbol));
    }
    manaString[i].innerHTML = newText;
  }
});

function addManaImgURL(symbol){
  if(symbol == "T") symbol = "tap";
  return "<img src=\"http://gatherer.wizards.com/Handlers/Image.ashx?size=medium&amp;name=" + symbol + "&amp;type=symbol\">";
}

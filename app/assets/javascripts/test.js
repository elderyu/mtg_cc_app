"use strict"
function myFunction(){
  // var txt = "input ok"
  // if(document.getElementById("id1").validity.rangeOverflow){
  //   txt = "number too big";
  // }
  // document.getElementById("demo").innerHTML = txt;

  var item, string = "";
  // var person = {
  //   name: "John",
  //   lname: "Doe",
  //   age: 25,
  //   language: "en",
  //   get lang(){
  //     return this.language.toUpperCase();
  //   },
  //   get fullName(){
  //     return this.name + " " + this.lname;
  //   }
  // };
  function Person(fname, lname, age, nationality){
    this.firstName = fname;
    this.lastName = lname;
    this.age = age;
    this.nationality = nationality;
    this.name = function(){
      return this.firstName + " " + this. lastName;
    }
  }
  var me = new Person("John", "Doe", 25, "fdsf");

  // for(item in person){
  //   string += person[item] + " ";
  // }

  document.getElementById("demo").innerHTML = document.getElementById("demo").nodeName;


}

function myFunction2(tmp){
  tmp.innerHTML = "Clicked!";
  document.getElementById("demo").innerHTML = document.getElementById("demo").nodeValue;
}

function changeText(){
  document.getElementById("btn1").innerHTML = "Hmm?";
}

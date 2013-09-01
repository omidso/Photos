/*
fraction.js
A Javascript fraction library.

Copyright (c) 2009  Erik Garrison <erik@hypervolu.me>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/
Fraction=function(t,n){if(t&&n)"number"==typeof t&&"number"==typeof n?(this.numerator=t,this.denominator=n):"string"==typeof t&&"string"==typeof n&&(this.numerator=parseInt(t),this.denominator=parseInt(n));else if(!n)if(num=t,"number"==typeof num)this.numerator=num,this.denominator=1;else if("string"==typeof num){var r,o;if([r,o]=num.split(" "),0===r%1&&o&&o.match("/"))return new Fraction(r).add(new Fraction(o));if(!r||o)return void 0;if("string"==typeof r&&r.match("/")){var e=r.split("/");this.numerator=e[0],this.denominator=e[1]}else{if("string"==typeof r&&r.match("."))return new Fraction(parseFloat(r));this.numerator=parseInt(r),this.denominator=1}}this.normalize()},Fraction.prototype.clone=function(){return new Fraction(this.numerator,this.denominator)},Fraction.prototype.toString=function(){var t=Math.floor(this.numerator/this.denominator),n=this.numerator%this.denominator,r=this.denominator,o=[];return 0!=t&&o.push(t),0!=n&&o.push(n+"/"+r),o.length>0?o.join(" "):0},Fraction.prototype.rescale=function(t){return this.numerator*=t,this.denominator*=t,this},Fraction.prototype.add=function(t){var n=this.clone();return t=t instanceof Fraction?t.clone():new Fraction(t),td=n.denominator,n.rescale(t.denominator),t.rescale(td),n.numerator+=t.numerator,n.normalize()},Fraction.prototype.subtract=function(t){var n=this.clone();return t=t instanceof Fraction?t.clone():new Fraction(t),td=n.denominator,n.rescale(t.denominator),t.rescale(td),n.numerator-=t.numerator,n.normalize()},Fraction.prototype.multiply=function(t){var n=this.clone();if(t instanceof Fraction)n.numerator*=t.numerator,n.denominator*=t.denominator;else{if("number"!=typeof t)return n.multiply(new Fraction(t));n.numerator*=t}return n.normalize()},Fraction.prototype.divide=function(t){var n=this.clone();if(t instanceof Fraction)n.numerator*=t.denominator,n.denominator*=t.numerator;else{if("number"!=typeof t)return n.divide(new Fraction(t));n.denominator*=t}return n.normalize()},Fraction.prototype.equals=function(t){t instanceof Fraction||(t=new Fraction(t));var n=this.clone().normalize(),t=t.clone().normalize();return n.numerator===t.numerator&&n.denominator===t.denominator},Fraction.prototype.normalize=function(){var t=function(t){return"number"==typeof t&&(t>0&&t%1>0&&1>t%1||0>t&&0>t%-1&&t%-1>-1)},n=function(t,n){if(n){var r=Math.pow(10,n);return Math.round(t*r)/r}return Math.round(t)};return function(){if(t(this.denominator)){var r=n(this.denominator,9),o=Math.pow(10,r.toString().split(".")[1].length);this.denominator=Math.round(this.denominator*o),this.numerator*=o}if(t(this.numerator)){var r=n(this.numerator,9),o=Math.pow(10,r.toString().split(".")[1].length);this.numerator=Math.round(this.numerator*o),this.denominator*=o}var e=Fraction.gcf(this.numerator,this.denominator);return this.numerator/=e,this.denominator/=e,this}}(),Fraction.gcf=function(t,n){var r=[],o=Fraction.primeFactors(t),e=Fraction.primeFactors(n);if(o.forEach(function(t){var n=e.indexOf(t);n>=0&&(r.push(t),e.splice(n,1))}),0===r.length)return 1;var i=function(){var t,n=r[0];for(t=1;t<r.length;t++)n*=r[t];return n}();return i},Fraction.primeFactors=function(t){for(var n=t,r=[],o=2;n>=o*o;)0===n%o?(r.push(o),n/=o):o++;return 1!=n&&r.push(n),r};
var COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg;
var FAT_ARROWS = /=>.*$/mg;

export default function getParameterNames(fn) {
  var code = fn.toString()
    .replace(COMMENTS, '')
    .replace(FAT_ARROWS, '');
  var result = code.slice(code.indexOf('(') + 1, code.indexOf(')'))

  return result;
}



const assert=require('node:assert/strict');
// Chained array inputs (Sorted Array(Filtered Array(...), ...)) do not nest
// predicates. A collection operation inside another operation's predicate does.
function nestedPredicates(source) {
 const iterators=new Set(['Is True For Any','Is True For All','Filtered Array','Mapped Array','Sorted Array']);
 const stack=[],findings=[];let quoted=false,escaped=false,line=1;
 for(let i=0;i<source.length;i++) {
  const c=source[i];if(c==='\n')line++;
  if(quoted){if(escaped)escaped=false;else if(c==='\\')escaped=true;else if(c==='"')quoted=false;continue;}
  if(c==='"'){quoted=true;continue;}
  if(c==='/'&&source[i+1]==='/'){while(i<source.length&&source[i]!=='\n')i++;line++;continue;}
  if(c==='(') {
   const name=source.slice(Math.max(0,i-64),i).match(/([A-Za-z][A-Za-z ]*)$/)?.[1].trim()||'';
   if(iterators.has(name)) {
    const parents=stack.filter(f=>f.iterator&&f.argument>=1);
    if(parents.length)findings.push({line,outer:parents.map(f=>f.name),inner:name});
   }
   stack.push({name,iterator:iterators.has(name),argument:0});
  }else if(c===','){if(stack.length)stack[stack.length-1].argument++;}
  else if(c===')'){assert(stack.length,'Unbalanced Workshop parentheses');stack.pop();}
 }
 assert.equal(stack.length,0);assert(!quoted);return findings;
}
function selfTest() {
 assert.equal(nestedPredicates('Is True For Any(Array(Event Player), Not(Is True For All(Array(True), Current Array Element)))').length,1);
 assert.equal(nestedPredicates('Sorted Array(Filtered Array(All Players(All Teams), Is Alive(Current Array Element)), Distance Between(Event Player, Current Array Element))').length,0);
 assert.equal(nestedPredicates('Mapped Array(Array(Event Player), First Of(Filtered Array(All Players(All Teams), True)))').length,1);
 assert.equal(nestedPredicates('Custom String("Is True For All(Array(True), True)", Null, Null, Null); // Is True For Any(\n').length,0);
}
module.exports={nestedPredicates,selfTest};

functor MkBigNumSubtract(structure BNA : BIGNUM_ADD) : BIGNUM_SUBTRACT =
struct
  structure Util = BNA.Util
  open Util
  open Seq

  exception NotYetImplemented
  infix 6 ++ --
  fun x ++ y = BNA.add (x, y)
 (*
  * 大整数相减
  * 条件：x和y均为正数且x>y。
  * 1）给y高位补零使x和y等长，便于计算；
  * 2）对y进行取反加一，不考虑符号位；
  * 3）x与y的补码模相加，结果消除多余零；
  * 以上三个步骤分别使用下面的三个“过程”表示
  *)  
  fun x -- y =
    if length y = 0 then x else
    if length y = 1 andalso nth y 0 = ZERO then x else
    let
      (*1、补0使之等长*)
      fun sameLen(x : bit seq, y : bit seq) = 
        let val tail = tabulate (fn i => ZERO) (length(x)-length(y))
        in append(y, tail) end;
      (*2、取补码*)
      fun trueToComp(x : bit seq) : bit seq = 
        (map (fn i => if i = ONE then ZERO else ONE) x) ++ singleton ONE;
      (*3、模相加并消零*)
      fun compSub (x : bit seq, cy: bit seq) : bit seq = 
        take(x ++ cy, length(x));
      (*4、判断相减后是否为零*)
      fun isZero (x : bit seq) = 
        (reduce (fn (i,j) => if i = ZERO andalso j = ZERO then ZERO else ONE)ZERO x) = ZERO;
      val ans = compSub(x, trueToComp(sameLen(x, y)))
    in
      if isZero(ans) then empty() else ans
    end;
  val sub = op--
end

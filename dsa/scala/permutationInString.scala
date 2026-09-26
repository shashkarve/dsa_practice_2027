Object Solution() {
    def checkInclusion(s1: String, s2: String): Boolean = {
        val charSet: Set[Char] = Set[Char]()
        var memo: Array[Int] = Array[Int].fill(-1)(26)
        var s1Memo: Array[Int] = Array[Int].fill(-1)(26)


        s1.foreach{ c => {
            memo(c.toInt - 'a'.toInt) += 1
            charSet.add(c)
        }}

        for(i <- 0 to s2.length-1) {
            var s2Memo: Array[Int] = Array[Int].fill(-1)(26)
            var inStreak: Boolean = false
            if(charSet.contains(s2(i))) {
                s2Memo(s2(i).toInt - 'a'.toInt) += 1
                if(!inStreak) {
                    inStreak=true
                } 
            }
            else {
                if(inStreak) {
                    if(s2Memo == s1Memo) {
                        return True
                    }
                    inStreak = false
                }
            }
        }
            false
    }
}
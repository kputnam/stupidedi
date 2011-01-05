module Stupidedi
  module FiftyTen
    module Base
      module TransactionSets

        class EightThirtyFive
        # class Header
        # : 100 ST    M   1
        # : 200 BPR   M   1
        # : 300 NTE   O   +
        # : 400 TRN   O   1
        # : 500 CUR   O   1
        # : 600 REF   O   +
        # : 700 DTM   O   +
        # :
        # : LOOP 1000        200
        # : :  800 N1    O   1
        # : :  900 N2    O   +
        # : : 1000 N3    O   +
        # : : 1100 N4    O   1
        # : : 1200 REF   O   +
        # : : 1300 PER   O   +
        # : : 1400 RDM   O   1
        # : : 1500 DTM   O   1
        # end

        # class Detail
        # : LOOP 2000      +
        # : : 30 LX    O   1
        # : : 50 TS3   O   1
        # : : 70 TS2   O   1
        # : :
        # : : LOOP 2100       +
        # : : : 100 CLP   M   1
        # : : : 200 CAS   O   99
        # : : : 300 NM1   M   9
        # : : : 330 MIA   O   1
        # : : : 350 MOA   O   1
        # : : : 400 REF   O   99
        # : : : 500 DTM   O   9
        # : : : 600 PER   O   3
        # : : : 620 AMT   O   20
        # : : :
        # : : : LOOP 2110         999
        # : : : :  700 SVC    O   1
        # : : : :  800 DTM    O   9
        # : : : :  900 CAS    O   99
        # : : : : 1000 REF    O   99
        # : : : : 1100 AMT    O   99
        # : : : : 1200 QTY    O   20
        # : : : : 1300 LQ     O   99
        # end

        # class Summary
        # : 100 PLB   O   +
        # : 200 SE    M   1
        # end
        end

      end
    end
  end
end

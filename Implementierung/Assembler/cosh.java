import java.util.HashMap;
import java.util.Map;

public class cosh {

    public static void main(String[] args) {
//        double solution = Math.co //todo

//        double solutionCalc = calcInverseCOSH(2.123);
//        System.out.println(solutionCalc);

//        double solutionCalc1 = calcCOSH(2);
//        System.out.println("Solution: " +solutionCalc1);

//        double solutionCalc2 = calcSINH(2);
//        System.out.println("Solution: " +solutionCalc2);



//        for(int i = 1; i<10; i++){
//            System.out.println("x = "+i+" Calculation: "+calcCOSH(i)+" Solution: "+Math.cosh(i));
//        }

//        for(int i = 1; i<20; i++){
//            System.out.println("x = "+i+" Calculation: "+calcSINH(i)+" Solution: "+Math.sinh(i));
//        }



        for(int i = 1; i<100; i++){
            System.out.println("x = "+i+" Calculation: "+calcInverseCOSH(i));
        }


    }

    public static Map< Double, Double> lookupTable = new HashMap<>();
    public static int depthTyler = 10;
    public static int depthNewton = 10;
    public static double X = 23.12; //tocalc

    public static double staticX1 = 1;


    public static void init(){
        int i = 0;

        while(i<1000){
            lookupTable.put((double)i,Math.cosh(i));
            i++;
        }

    }

    public static double calcCOSH(double x){
        double result  = 0;

    for(int i = 0; i<depthTyler; i++){
//        double cur = Math.pow(x,2*i)/(fak(2*i));
        double cur=1;
        for (int j = 1; j <= 2 * i; j++) {
            cur*=x/j;
        }

//        System.out.println(cur);
        result+= cur;
    }
        return result;
    }

    public static double calcSINH(double x){
        double result  = x;

        for(int i = 1; i<depthTyler; i++){
            double cur = 1;
            for (int j = 1; j <= 2 * i; j++) {
                cur*=x/j;
            }
            result+= cur;
        }
        return result;
    }

    public static double calcInverseCOSH(double x){

        double Xn = staticX1;

        for(int i = 0; i<depthNewton; i++){
            double fx = calcCOSH(Xn) - x;
//            System.out.println("fx: "+fx);
            double fxAbleitung = calcSINH(Xn);
//            System.out.println("fxAbleitung: "+fxAbleitung);

            double cur = fx/fxAbleitung;
//            System.out.println("cur: "+cur);
            Xn = Xn - fx/fxAbleitung;
//            System.out.println("Xn = "+Xn);
//            System.out.println();

        }

        return Xn;
    }

    public static int fak(int n){
        if(n == 0)return 1;

        int result = 1;
        for(int i = 1 ; i<=n; i++){
            result*=i;
        }
        return result;
    }






}

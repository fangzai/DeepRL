import java.util.Random;

public class HelicopterMain {

    public static void main(String[] args) {
        System.out.println("操作无人机模型----启动--------");
        HelicopterMain myHeli = new HelicopterMain();
/*        Random randomNumberGenerator = new Random();

        for(int i=0;i<100;i++)
        {
            System.out.print(randomNumberGenerator.nextDouble());
            System.out.print("  ->");
            if((i+1)%10==0)
            {
                System.out.println();
            }
        }
        System.out.println();*/
        //myHeli.operation();
        //myHeli.operateHeli();
        HelicopterState myHelieState = new HelicopterState();
        myHelieState.wind[0] =0;
        myHelieState.wind[1] =0;
        System.out.println("old information......");
        System.out.println("position :  ");
        myHeli.display(myHelieState.position);
        System.out.println("velocity :  ");
        myHeli.display(myHelieState.velocity);
        System.out.println("position :  ");
        myHeli.display(myHelieState.position);
        double [] myAction = {0.5,0.5,0.5,0.5};

        // update state
        myHelieState.stateUpdate(myAction);
        double [] observe = myHelieState.makeObservation();
        myHeli.showArray(observe);
        /*
        System.out.println("old information......");
        System.out.println("position :  ");
        myHeli.display(myHelieState.position);
        System.out.println("velocity :  ");
        myHeli.display(myHelieState.velocity);
        System.out.println("angular_rate :  ");
        myHeli.display(myHelieState.angular_rate);
        */


        System.out.println("操作无人机模型-----中止-------");
    }
    public  void operateHeli()
    {
        //定义风向
        double [] wind = new double[2];
        wind[0] = 0.0d;
        wind[1] = 0.0d;
        double [] state = new double[12]; // 12个状态
        double [] action = new double[4]; // 4个状态
        action[0] = 0.2d;
        action[1] =-0.1d;
        action[2] = 0.2d;
        action[3] =-0.1d;
        double [] ro = new double[1+12+1]; //包含reward nextState isterminal等信息
        Helicopter myHelicopter = new Helicopter(wind);
        System.out.println(myHelicopter.env_init()); //初始化无人机
        state = myHelicopter.env_start();
        //showArray(state);
        ro = myHelicopter.env_step(action);
        System.out.println("下一时刻的信息");
        showArray(ro);

        state = myHelicopter.makeObservation();
        System.out.println("下一时刻的状态");
        showArray(state);

    }
    public void showArray(double [] myArray)
    {
        for(int i = 0;i < myArray.length;i++)
        {
            System.out.print(Integer.toString(i)+" "+myArray[i]+" \n");
        }
        System.out.print("\n");
    }
    public void  operation() {
        double x =0.4, y =0.1, z = 0.3, w =0.9;
        HeliVector meHi = new HeliVector(x,y,z);
        //this.display(meHi.rotate(new Quaternion(x,y,z,w)));
        this.display(meHi.express_in_quat_frame(new Quaternion(x, y, z, w)));
        /*Quaternion myQ = new Quaternion(x,y,z,w);

        Quaternion myQ_conj = myQ.conj();
        System.out.println("显示共轭向量---其实我也不知道这是怎么算出来的^^^^^");
        display(myQ_conj);

        Quaternion myQ_mult = myQ.mult(myQ_conj);
        System.out.println("向量之间乘法---其实我也不知道这是怎么算出来的^^^^^");
        display(myQ_mult);*/


    }
    public void display(Quaternion myQ) {
        System.out.println("x: " + String.valueOf(myQ.x));
        System.out.println("y: "+String.valueOf(myQ.y));
        System.out.println("z: "+String.valueOf(myQ.z));
        System.out.println("w: "+String.valueOf(myQ.w));
    }
    public void display(HeliVector myQ) {
        System.out.println("x: " + String.valueOf(myQ.x));
        System.out.println("y: "+String.valueOf(myQ.y));
        System.out.println("z: "+String.valueOf(myQ.z));
    }
}

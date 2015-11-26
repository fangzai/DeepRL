/* Helicopter Domain  for RL - Competition - RLAI's Port of Pieter Abbeel's code submission
 * Copyright (C) 2007, Pieter Abbeel
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA. */
//package org.rlcommunity.environments.helicopter;

import java.net.URL;


public class Helicopter {

    double [] o = new double[13-1];  //这个地方需要确定一下维数
    HelicopterState heli = new HelicopterState();
    double [] ro =new double[1+12+1];  //包括reward nextAction[4] isterminal

    public Helicopter() {
        this.getDefaultParameters();
    }

    public Helicopter(double [] p) {
        // 构造函数  不是特别明确
        if (p != null) {
            setWind0(p[0]);
            setWind1(p[1]);
        }
    }


    public static double[] getDefaultParameters() {
        double [] p = new double[2]; //两个风
       /* p.addDoubleParam("Wind 0 [-1.0d,1.0d]", 0.0d);  //默认系数是0
        p.setAlias("wind0", "Wind 0 [-1.0d,1.0d]");    //默认风向是 （-1，1）
        p.addDoubleParam("Wind 1 [-1.0d,1.0d]", 0.0d);
        p.setAlias("wind1", "Wind 1 [-1.0d,1.0d]");*/
        p[0]= 0.0d;
        p[1]= 0.0d;
        return p;
    }

    public void setWind0(double newValue) {
        //输入参数是一个double类型的
        heli.wind[0] = newValue * HelicopterState.WIND_MAX;
    }

    public void setWind1(double newValue) {
        heli.wind[1] = newValue * HelicopterState.WIND_MAX;
    }

    public String env_init() {
        //o = new double[13-1];
        //return makeTaskSpec();
        return "Welcome to the world of Helicopter......";
    }

    public double [] env_start() {
        // start at origin, zero velocity, zero angular rate, perfectly level and facing north
        heli.reset();
        return makeObservation();
    }

    public double [] env_step(double [] action) {
        heli.stateUpdate(action);
        heli.num_sim_steps++;
        heli.env_terminal = heli.env_terminal || (heli.num_sim_steps == HelicopterState.NUM_SIM_STEPS_PER_EPISODE);

        int isTerminal = 0;
        if (heli.env_terminal) {
            isTerminal = 1;
        }

        ro = new double[1+12+1]; //和函数中定义的那个ro一样
        ro[0] = this.getReward();
        for( int i = 0;i <12 ;i++)
        {
            ro[1+i] = this.makeObservation()[i];
        }
        ro[13] = isTerminal;
        return ro;
    }

    public void env_cleanup() {
    }


    // goal state is all zeros, quadratically penalize for deviation:
    // 目标状态是全部为0，怎么是这么设计的
    double getReward() {
        double reward = 0;
        if (!heli.env_terminal) { // not in terminal state
            reward -= heli.velocity.x * heli.velocity.x;
            reward -= heli.velocity.y * heli.velocity.y;
            reward -= heli.velocity.z * heli.velocity.z;
            reward -= heli.position.x * heli.position.x;
            reward -= heli.position.y * heli.position.y;
            reward -= heli.position.z * heli.position.z;
            reward -= heli.angular_rate.x * heli.angular_rate.x;
            reward -= heli.angular_rate.y * heli.angular_rate.y;
            reward -= heli.angular_rate.z * heli.angular_rate.z;
            reward -= heli.q.x * heli.q.x;
            reward -= heli.q.y * heli.q.y;
            reward -= heli.q.z * heli.q.z;
        }
        else
        {   // in terminal state, obtain very negative reward b/c the agent will exit,
            // we have to give out reward for all future times
            reward = -3.0f * HelicopterState.MAX_POS * HelicopterState.MAX_POS +
                    -3.0f * HelicopterState.MAX_RATE * HelicopterState.MAX_RATE +
                    -3.0f * HelicopterState.MAX_VEL * HelicopterState.MAX_VEL -
                    (1.0f - HelicopterState.MIN_QW_BEFORE_HITTING_TERMINAL_STATE * HelicopterState.MIN_QW_BEFORE_HITTING_TERMINAL_STATE);
            reward *= (float) (HelicopterState.NUM_SIM_STEPS_PER_EPISODE - heli.num_sim_steps);

        //System.out.println("Final reward is: "+reward+" NUM_SIM_STEPS_PER_EPISODE="+HelicopterState.NUM_SIM_STEPS_PER_EPISODE +"  heli.num_sim_steps="+ heli.num_sim_steps);
        }
        return reward;

    }

    //This method creates the object that can be used to easily set different problem parameters
    //@Override  貌似这个函数没什么用
    protected double [] makeObservation() {
        return heli.makeObservation();
    }

    public double getMaxValueForQuerableVariable(int dimension) {
        switch (dimension) {
            case 0:
                return HelicopterState.MAX_VEL;
            case 1:
                return HelicopterState.MAX_VEL;
            case 2:
                return HelicopterState.MAX_VEL;
            case 3:
                return HelicopterState.MAX_POS;
            case 4:
                return HelicopterState.MAX_POS;
            case 5:
                return HelicopterState.MAX_POS;
            case 6:
                return HelicopterState.MAX_RATE;
            case 7:
                return HelicopterState.MAX_RATE;
            case 8:
                return HelicopterState.MAX_RATE;
            case 9:
                return HelicopterState.MAX_QUAT;
            case 10:
                return HelicopterState.MAX_QUAT;
            case 11:
                return HelicopterState.MAX_QUAT;
            case 12:
                return HelicopterState.MAX_QUAT;
            default:
                System.out.println("Invalid Dimension in getMaxValueForQuerableVariable for Helicopter");
                return Double.POSITIVE_INFINITY;
        }
    }

    public double getMinValueForQuerableVariable(int dimension) {
        switch (dimension) {
            case 0:
                return -HelicopterState.MAX_VEL;
            case 1:
                return -HelicopterState.MAX_VEL;
            case 2:
                return -HelicopterState.MAX_VEL;
            case 3:
                return -HelicopterState.MAX_POS;
            case 4:
                return -HelicopterState.MAX_POS;
            case 5:
                return -HelicopterState.MAX_POS;
            case 6:
                return -HelicopterState.MAX_RATE;
            case 7:
                return -HelicopterState.MAX_RATE;
            case 8:
                return -HelicopterState.MAX_RATE;
            case 9:
                return -HelicopterState.MAX_QUAT;
            case 10:
                return -HelicopterState.MAX_QUAT;
            case 11:
                return -HelicopterState.MAX_QUAT;
            case 12:
                return -HelicopterState.MAX_QUAT;
            default:
                System.out.println("Invalid Dimension in getMaxValueForQuerableVariable for Helicopter");
                return Double.NEGATIVE_INFINITY;
        }
    }

    public String getVisualizerClassName() {
        return "hello world";
        //return HelicopterVisualizer.class.getName();  //原来返回的是这个
    }
    public URL getImageURL() {
       URL imageURL = Helicopter.class.getResource("/images/helicopter.png");
       return imageURL;
   }
    /*public static void main(String[] args){
        //EnvironmentLoader L=new EnvironmentLoader(new Helicopter());
        //L.run();
        Helicopter myHeli = new Helicopter();
    }*/
}

class DetailsProvider {

    public String getName() {
        return "Helicopter Hovering 1.0";
    }

    public String getShortName() {
        return "Helicopter";
    }

    public String getAuthors() {
        return "Pieter Abbeel, Mark Lee, Brian Tanner";
    }

    public String getInfoUrl() {
        return "http://library.rl-community.org/helicopter";
    }

    public String getDescription() {
        return "Helicopter Hovering Reinforcement Learning problem.";
    }
}

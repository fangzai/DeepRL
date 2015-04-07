//package org.rlcommunity.environments.helicopter;

public class HeliVector {
	//理论上 直升机一般是三维向量操作，但是需要通过四维向量的操作来完成计算
	//所以就有了HeliVector -> Quaternion 的转换
	public double x;
	public double y;
	public double z;
	
	public HeliVector(HeliVector vecToCopy) {
		this.x = vecToCopy.x;
		this.y = vecToCopy.y;
		this.z = vecToCopy.z;
	}
	
	public HeliVector(double x, double y, double z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public Quaternion to_quaternion() {
		Quaternion quat;
		double rotation_angle = Math.sqrt(x*x + y*y + z*z);
		if(rotation_angle < 1e-4){
			// avoid division by zero -- also: can use simpler computation in this case,
			// since for small angles sin(x) = x is a good approximation
			quat = new Quaternion(x/2.0f,y/2.0f,z/2.0f,0.0f);
			quat.w = Math.sqrt(1.0f - (quat.x*quat.x + quat.y*quat.y + quat.z*quat.z));
		} else { 
			quat = new Quaternion(Math.sin(rotation_angle/2.0f)*(x/rotation_angle),
														Math.sin(rotation_angle/2.0f)*(y/rotation_angle),
														Math.sin(rotation_angle/2.0f)*(z/rotation_angle),
														Math.cos(rotation_angle/2.0f));
		}
		return quat;
	}
	
	public HeliVector rotate(Quaternion q) {
		return q.mult(new Quaternion(this)).mult(q.conj()).complex_part();
	}
	
	public HeliVector express_in_quat_frame(Quaternion q) {
		return this.rotate(q.conj());
	}

    void stringSerialize(StringBuffer b) {
		//这个函数没有什么作用，应该也是用不到的  没什么意义，主要是输出方便
        b.append("x_"+x);
        b.append("y_"+y);
        b.append("z_"+z);
    }
}
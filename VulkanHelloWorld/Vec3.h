//Vec3 implementation developed as part of the Foundations of Modelling & Rendering Course

#ifndef VEC_3_H
#define VEC_3_H

#include <math.h>

template<class T>
class Vec3
{

public:

	T x, y, z;

	Vec3<T>()
	{
		x = y = z = 0;
	}

	Vec3<T>(const Vec3<T>& v)
	{
		x = v.getX();
		y = v.getY();
		z = v.getZ();
	}

	Vec3<T>(T x, T y, T z)
	{
		this->x = x;
		this->y = y;
		this->z = z;
	}

	const T& getX() const { return x; }
	const T& getY() const { return y; }
	const T& getZ() const { return z; }

	void setX(T x) { this->x = x; }
	void setY(T y) { this->y = y; }
	void setZ(T z) { this->z = z; }

	Vec3 operator+ (const Vec3& v) const
	{
		return Vec3(x + v.getX(), y + v.getY(), z + v.getZ());
	}

	Vec3 operator- () const
	{
		return Vec3(-x, -y, -z);
	}

	Vec3 operator- (const Vec3& v) const
	{
		return Vec3(x - v.getX(), y - v.getY(), z - v.getZ());
	}

	Vec3 operator* (float s) const
	{
		return Vec3(s*x, s*y, s*z);
	}

	Vec3 operator/ (float s) const
	{
		return Vec3(x / s, y / s, z / s);
	}

	T operator[] (int i) const
	{
		if (i < 0 || i >2) return 0;
		const T * p = &x;
		return *(p + i);
	}

	T dotProduct(const Vec3& v) const
	{
		return x*v.getX() + y*v.getY() + z*v.getZ();
	}

	Vec3 crossProduct(const Vec3& v) const
	{
		return Vec3(y*v.getZ() - z*v.getY(), z*v.getX() - x*v.getZ(), x*v.getY() - y*v.getX());
	}

	T getLength() const
	{
		return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
	}

	Vec3 getNormal() const
	{
		return Vec3(x / getLength(), y / getLength(), z / getLength());
	}
};

#endif
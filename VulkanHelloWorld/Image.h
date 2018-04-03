//Image implementation developed as part of the Foundations of Modelling & Rendering Course

#ifndef IMAGE_H
#define IMAGE_H

#include "math.h"
#include "Vec3.h"
#include <vector>

class Image
{

private:

	int m_width, m_height;
	std::vector<Vec3<unsigned char>> m_values; //Radiance of each pixel

public:

	Image() {};

	Image(const int width, const int height) : m_width(width), m_height(height), m_values(height*width) {};

	int getWidth() const { return m_width; }
	int getHeight() const { return m_height; }

	const Vec3<unsigned char>& getValue(const int x, const int y);

	void set(const int x, const int y, const Vec3<unsigned char>& value);

	void set(const int i, const Vec3<unsigned char>& value)
	{
		m_values[i] = value;
	}

	const Vec3<unsigned char>& get(int x, int y) const
	{
		return m_values[x + y * m_width];
	}

	void saveP3(const std::string& filename) const;

	void saveP6(const std::string& filename) const;
};

#endif
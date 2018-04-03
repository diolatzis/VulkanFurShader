#include "Image.h"

const Vec3<unsigned char>& Image::getValue(const int x, const int y)
{
	return m_values[x + y*m_width];
}

void Image::set(const int x, const int y, const Vec3<unsigned char>& value)
{
	m_values[x + y*m_width] = value;
}

//Save image to ppm
void Image::saveP6(const std::string& filename) const 
{
	FILE* file = fopen(filename.c_str(), "wb");
	fprintf(file, "P6 %d %d 255\n", m_width, m_height);
	for (int y = 0; y < m_height; ++y) 
	{
		for (int x = 0; x < m_width; ++x) 
		{
			fwrite(&get(x, y), sizeof(unsigned char), 3, file);
		}
	}
	fclose(file);
}

void Image::saveP3(const std::string& filename) const
{
	FILE* file = fopen(filename.c_str(), "wt");
	fprintf(file, "P3 %d %d 255\n", m_width, m_height);
	for (int y = 0; y < m_height; ++y)
	{
		fprintf(file, "\n# y = %d\n", y);
		for (int x = 0; x < m_width; ++x)
		{
			const Vec3<unsigned char> c(get(x, y));
			fprintf(file, "%d %d %d\n",
			(int)c[0],
			(int)c[1],
			(int)c[2]);
		}
	}
	fclose(file);
}
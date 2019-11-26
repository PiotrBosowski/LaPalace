char getR(const char * image, int width, int y, int x)
{
	return image[3 * (y * width + x) + 0];
}
char getG(const char * image, int width, int y, int x)
{
	return image[3 * (y * width + x) + 1];
}
char getB(const char * image, int width, int y, int x)
{
	return image[3 * (y * width + x) + 2];
}

void setR(char * image, int width, int y, int x, char value)
{
	image[3 * (y * width + x) + 0] = value;
}
void setG(char * image, int width, int y, int x, char value)
{
	image[3 * (y * width + x) + 1] = value;
}
void setB(char * image, int width, int y, int x, char value)
{
	image[3 * (y * width + x) + 2] = value;
}

extern "C" __declspec(dllexport) void transformSingleImage(char * input, char * output, int height, int width)
{
	int pattern[3][3] = 
	{
		{0, 2, 0},
		{2, -8, 2},
		{0, 2, 0}
	};

	for (int i = 1; i < height - 1; i++)
	{
		for (int j = 1; j < width - 1; j++)
		{
			output[3 * (i * width + j)] = 0;
			output[3 * (i * width + j)+1] = 0;
			output[3 * (i * width + j)+2] = 0;
			/*
			char red = getR(input, width, i, j) * pattern[1][1];
			red += getR(input, width, i - 1, j - 1) * pattern[0][0];
			red += getR(input, width, i - 1, j + 0) * pattern[0][1];
			red += getR(input, width, i - 1, j + 1) * pattern[0][2];
			red += getR(input, width, i + 0, j - 1) * pattern[1][0];
			red += getR(input, width, i + 0, j + 1) * pattern[1][2];
			red += getR(input, width, i + 1, j - 1) * pattern[2][0];
			red += getR(input, width, i + 1, j + 0) * pattern[2][1];
			red += getR(input, width, i + 1, j + 1) * pattern[2][2];
			setR(output, width, i, j, red);

			char green = getG(input, width, i, j) * pattern[1][1];
			green += getG(input, width, i - 1, j - 1) * pattern[0][0];
			green += getG(input, width, i - 1, j + 0) * pattern[0][1];
			green += getG(input, width, i - 1, j + 1) * pattern[0][2];
			green += getG(input, width, i + 0, j - 1) * pattern[1][0];
			green += getG(input, width, i + 0, j + 1) * pattern[1][2];
			green += getG(input, width, i + 1, j - 1) * pattern[2][0];
			green += getG(input, width, i + 1, j + 0) * pattern[2][1];
			green += getG(input, width, i + 1, j + 1) * pattern[2][2];
			setG(output, width, i, j, green);

			char blue = getB(input, width, i, j) * pattern[1][1];
			blue += getB(input, width, i - 1, j - 1) * pattern[0][0];
			blue += getB(input, width, i - 1, j + 0) * pattern[0][1];
			blue += getB(input, width, i - 1, j + 1) * pattern[0][2];
			blue += getB(input, width, i + 0, j - 1) * pattern[1][0];
			blue += getB(input, width, i + 0, j + 1) * pattern[1][2];
			blue += getB(input, width, i + 1, j - 1) * pattern[2][0];
			blue += getB(input, width, i + 1, j + 0) * pattern[2][1];
			blue += getB(input, width, i + 1, j + 1) * pattern[2][2];
			setB(output, width, i, j, green);
			*/
		}
	}
}
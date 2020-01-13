char* pixel(char* scan0, int x, int y, int stride, int bitsPerPixel)
{
	return scan0 + y * stride + x * bitsPerPixel / 8;
}

extern "C" __declspec(dllexport) void TransformImageCpp(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int* pattern)
{
	for (int i = 1; i < height - 1; ++i)
		for (int j = 1; j < width - 1; ++j)
		{
			int newColorValue = 0;
			newColorValue += (unsigned char)pixel(input, j - 1, i - 1, inputStride, inputBitsPerPixel)[0] * pattern[0];
			newColorValue += (unsigned char)pixel(input, j    , i - 1, inputStride, inputBitsPerPixel)[0] * pattern[1];
			newColorValue += (unsigned char)pixel(input, j + 1, i - 1, inputStride, inputBitsPerPixel)[0] * pattern[2];
			newColorValue += (unsigned char)pixel(input, j - 1, i    , inputStride, inputBitsPerPixel)[0] * pattern[3];
			newColorValue += (unsigned char)pixel(input, j    , i    , inputStride, inputBitsPerPixel)[0] * pattern[4];
			newColorValue += (unsigned char)pixel(input, j + 1, i    , inputStride, inputBitsPerPixel)[0] * pattern[5];
			newColorValue += (unsigned char)pixel(input, j - 1, i + 1, inputStride, inputBitsPerPixel)[0] * pattern[6];
			newColorValue += (unsigned char)pixel(input, j    , i + 1, inputStride, inputBitsPerPixel)[0] * pattern[7];
			newColorValue += (unsigned char)pixel(input, j + 1, i + 1, inputStride, inputBitsPerPixel)[0] * pattern[8];
			newColorValue = newColorValue > 255 ? 255 : newColorValue < 0 ? 0 : newColorValue;
			pixel(output, j, i, outputStride, outputBitsPerPixel)[0] = (unsigned char)newColorValue;
			
			newColorValue = 0;
			newColorValue += (unsigned char)pixel(input, j - 1, i - 1, inputStride, inputBitsPerPixel)[1] * pattern[0];
			newColorValue += (unsigned char)pixel(input, j    , i - 1, inputStride, inputBitsPerPixel)[1] * pattern[1];
			newColorValue += (unsigned char)pixel(input, j + 1, i - 1, inputStride, inputBitsPerPixel)[1] * pattern[2];
			newColorValue += (unsigned char)pixel(input, j - 1, i    , inputStride, inputBitsPerPixel)[1] * pattern[3];
			newColorValue += (unsigned char)pixel(input, j    , i    , inputStride, inputBitsPerPixel)[1] * pattern[4];
			newColorValue += (unsigned char)pixel(input, j + 1, i    , inputStride, inputBitsPerPixel)[1] * pattern[5];
			newColorValue += (unsigned char)pixel(input, j - 1, i + 1, inputStride, inputBitsPerPixel)[1] * pattern[6];
			newColorValue += (unsigned char)pixel(input, j    , i + 1, inputStride, inputBitsPerPixel)[1] * pattern[7];
			newColorValue += (unsigned char)pixel(input, j + 1, i + 1, inputStride, inputBitsPerPixel)[1] * pattern[8];
			newColorValue = newColorValue > 255 ? 255 : newColorValue < 0 ? 0 : newColorValue;
			pixel(output, j, i, outputStride, outputBitsPerPixel)[1] = (unsigned char)newColorValue;
			
			newColorValue = 0;
			newColorValue += (unsigned char)pixel(input, j - 1, i - 1, inputStride, inputBitsPerPixel)[2] * pattern[0];
			newColorValue += (unsigned char)pixel(input, j    , i - 1, inputStride, inputBitsPerPixel)[2] * pattern[1];
			newColorValue += (unsigned char)pixel(input, j + 1, i - 1, inputStride, inputBitsPerPixel)[2] * pattern[2];
			newColorValue += (unsigned char)pixel(input, j - 1, i    , inputStride, inputBitsPerPixel)[2] * pattern[3];
			newColorValue += (unsigned char)pixel(input, j    , i    , inputStride, inputBitsPerPixel)[2] * pattern[4];
			newColorValue += (unsigned char)pixel(input, j + 1, i    , inputStride, inputBitsPerPixel)[2] * pattern[5];
			newColorValue += (unsigned char)pixel(input, j - 1, i + 1, inputStride, inputBitsPerPixel)[2] * pattern[6];
			newColorValue += (unsigned char)pixel(input, j    , i + 1, inputStride, inputBitsPerPixel)[2] * pattern[7];
			newColorValue += (unsigned char)pixel(input, j + 1, i + 1, inputStride, inputBitsPerPixel)[2] * pattern[8];
			newColorValue = newColorValue > 255 ? 255 : newColorValue < 0 ? 0 : newColorValue;
			pixel(output, j, i, outputStride, outputBitsPerPixel)[2] = (unsigned char)newColorValue;
		}
}
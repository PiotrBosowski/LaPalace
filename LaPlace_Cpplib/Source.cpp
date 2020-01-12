char* pixel(char* scan0, int x, int y, int stride, int bitsPerPixel)
{
	return scan0 + y * stride + x * bitsPerPixel / 8;
}

extern "C" __declspec(dllexport) void TransformImageCpp(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int* pattern)
{
	for (int i = 1; i < height - 1; ++i)
		for (int j = 1; j < width - 1; ++j)
		{
			for (int color = 0; color < 3; ++color)
			{
				int newPixelValue = 0;
				newPixelValue += (unsigned char)pixel(input, j - 1, i - 1, inputStride, inputBitsPerPixel)[color] * pattern[0];
				newPixelValue += (unsigned char)pixel(input, j    , i - 1, inputStride, inputBitsPerPixel)[color] * pattern[1];
				newPixelValue += (unsigned char)pixel(input, j + 1, i - 1, inputStride, inputBitsPerPixel)[color] * pattern[2];
				newPixelValue += (unsigned char)pixel(input, j - 1, i    , inputStride, inputBitsPerPixel)[color] * pattern[3];
				newPixelValue += (unsigned char)pixel(input, j    , i    , inputStride, inputBitsPerPixel)[color] * pattern[4];
				newPixelValue += (unsigned char)pixel(input, j + 1, i    , inputStride, inputBitsPerPixel)[color] * pattern[5];
				newPixelValue += (unsigned char)pixel(input, j - 1, i + 1, inputStride, inputBitsPerPixel)[color] * pattern[6];
				newPixelValue += (unsigned char)pixel(input, j    , i + 1, inputStride, inputBitsPerPixel)[color] * pattern[7];
				newPixelValue += (unsigned char)pixel(input, j + 1, i + 1, inputStride, inputBitsPerPixel)[color] * pattern[8];
				newPixelValue = newPixelValue > 255 ? 255 : newPixelValue < 0 ? 0 : newPixelValue;
				pixel(output, j, i, outputStride, outputBitsPerPixel)[color] = 255 - (unsigned char)newPixelValue;
			}
		}
}
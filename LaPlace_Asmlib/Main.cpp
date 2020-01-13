extern "C" __declspec(dllexport) void TransformImageAsm(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int* pattern);

extern "C" void Transform(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int* pattern);

void TransformImageAsm(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int* pattern)
{
	Transform(input, output, height, width, inputStride, outputStride, inputBitsPerPixel, outputBitsPerPixel, pattern);
	return;
}
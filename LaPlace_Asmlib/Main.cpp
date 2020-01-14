extern "C" __declspec(dllexport) void TransformImageAsm(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int* pattern, int beginLine, int endLine);

extern "C" void Transform(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int* pattern, int beginLine, int endLine);

void TransformImageAsm(char * input, char * output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int* pattern, int beginLine, int endLine)
{
	Transform(input, output, height, width, inputStride, outputStride, inputBitsPerPixel, outputBitsPerPixel, pattern, beginLine, endLine);
	return;
}
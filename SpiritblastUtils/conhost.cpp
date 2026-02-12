#include "baseinc.h"
#include <cstdio>

// Copied over from spicytopping-utils

extern bool consoleAllocated = false;

func double conhost_init()
{
	if (consoleAllocated)
		return true;

	int allocResult = AllocConsole();
	if (allocResult != 0)
	{
		consoleAllocated = true;

		FILE *confile;
		freopen_s(&confile, "CONOUT$", "w", stdout);
		freopen_s(&confile, "CONOUT$", "w", stderr);
		freopen_s(&confile, "CONIN$", "r", stdin);

		return true;
	}

	return false;
}

func double conhost_free()
{
	if (!consoleAllocated)
		return false;

	int freeResult = FreeConsole();
	if (freeResult != 0)
	{
		consoleAllocated = false;
		return true;
	}

	return false;
}

func double conhost_is_allocated()
{
	if (consoleAllocated)
		return true;
	return false;
}

func double conhost_write(const char *writeOutput)
{
	if (!consoleAllocated)
		return false;

	HANDLE stdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
	int writeResult = 0;
	if (stdOutput != NULL && stdOutput != INVALID_HANDLE_VALUE)
	{
		DWORD charsWritten = 0;
		writeResult = WriteConsoleA(stdOutput, writeOutput, strlen(writeOutput), &charsWritten, NULL);

		static string newlineString = "\n";
		const char *newlineChar = newlineString.c_str();
		WriteConsoleA(stdOutput, newlineChar, strlen(newlineChar), &charsWritten, NULL);
	}

	return double(writeResult);
}

func double conhost_set_color(double textColor, double bgColor)
{
	if (!consoleAllocated)
		return false;

	HANDLE stdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
	SetConsoleTextAttribute(stdOutput, (int(bgColor) << 4) | int(textColor));

	return true;
}

func double conhost_title(const char *newTitle)
{
	if (!consoleAllocated)
		return false;

	int titleResult = SetConsoleTitleA(newTitle);
	return double(titleResult);
}
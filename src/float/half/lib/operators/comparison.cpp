#include "../half.h"
using namespace floating;

bool Half::operator==(const Half &s)
{
    return data.raw == s.data.raw;
}

bool Half::operator==(const float &f)
{
    // TODO: conversion VCVTPS2PH
    return false;
}

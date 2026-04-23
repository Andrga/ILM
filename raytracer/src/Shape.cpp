#include "Shape.h"

Shape::Shape(): _material(nullptr)
{
}

Shape::Shape(std::shared_ptr<Material> mat) : _material(mat) {
	
}

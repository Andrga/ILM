#pragma once
#include "Material.h"
#include "Ray.hpp"
class Shape {
public:
	Shape(Material* mat);
	virtual bool Intersect(const Ray& ray, float tMin, float tMax) const = 0;
	void setMaterial(Material* mat) {
		_material = mat;
	}
	Material* getMaterial() const {
		return _material;
	}
protected:
	Material* _material;
};


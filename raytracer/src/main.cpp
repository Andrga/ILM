#include "glm/vec3.hpp"
#include "glm/geometric.hpp"
#include "Film.h"
#include "Color.h"
#include "Camera.hpp"

#include <fstream>
#include <vector>

#include "Renderer.h"
#include "Shape.h"
#include "Sphere.h"

const glm::vec3 sphere_position{0.0, 0.0, 1.0};
static std::vector<Shape*> shapes;

int main(void) {
    std::ofstream outFile("imagen.ppm");
    Film film(800, 600, outFile);

    Camera camera(
        { 0.0, 0.0, 0.0 },
        sphere_position,
        { 0.0, 1.0, 0.0 },
        film,
        90.0
    );

    Sphere* sphere = new Sphere(sphere_position, 0.5, new Material(new Color(1,0,1)));
    shapes.push_back(sphere);
    Renderer renderer(&film, &camera, shapes);
    renderer.Render();
    return 0;
}

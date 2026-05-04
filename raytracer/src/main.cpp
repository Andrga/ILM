#include "glm/vec3.hpp"
#include "glm/geometric.hpp"
#include "Film.h"
#include "Color.h"
#include "Camera.hpp"

#include <fstream>
#include <vector>

#include "Renderer.h"
#include "Scene.h"
#include "Sphere.h"
#include "Quad.h"
#include "DirectionalLight.h"
#include "PointLight.h"
#include "TextureGridColor.h"
#include "TextureConstColor.h"
#include "glm/gtc/constants.hpp"


//  Cambia este valor para elegir la escena a renderizar
#define SCENE 3

//  Helpers de textura
static TextureGridColor* grid(Color a, Color b, int cu, int cv) {
    return new TextureGridColor(
        std::make_shared<TextureConstColor>(a),
        std::make_shared<TextureConstColor>(b),
        cu, cv);
}

static TextureGridColor* nestedGrid(Color a1, Color a2, Color b,
    int innerU, int innerV,
    int outerU, int outerV) {
    auto inner = std::make_shared<TextureGridColor>(
        std::make_shared<TextureConstColor>(a1),
        std::make_shared<TextureConstColor>(a2),
        innerU, innerV);
    return new TextureGridColor(inner, std::make_shared<TextureConstColor>(b), outerU, outerV);
}

#pragma region Escena 1
#if SCENE == 1

static std::shared_ptr<Material> makeAzul() { return std::make_shared<Material>(BLUE, 0.8f); }
static std::shared_ptr<Material> makeAmarillo() { return std::make_shared<Material>(MAGENTA, 0.02f); }

static std::shared_ptr<Material> makeCuadros() {
    return std::make_shared<Material>(grid(WHITE, BLACK, 8, 8), 0.5f);
}

static std::shared_ptr<Material> makeVerde() {
    auto inner = std::make_shared<TextureGridColor>(
        std::make_shared<TextureConstColor>(GREEN),
        std::make_shared<TextureConstColor>(DARK_GREEN), 4, 4);
    return std::make_shared<Material>(
        new TextureGridColor(inner, std::make_shared<TextureConstColor>(DARK_GREEN), 4, 4),
        0.9f);
}

static void buildScene(Scene& scene) {
    scene.addShape(std::make_shared<Sphere>(glm::vec3(2, 0, 0), 1.0f, makeAzul()));
    scene.addShape(std::make_shared<Sphere>(glm::vec3(0, 2, -2), 1.0f, makeAmarillo()));
    scene.addShape(std::make_shared<Sphere>(glm::vec3(-2, 0, -2), 1.0f, makeCuadros()));
    scene.addShape(std::make_shared<Quad>(
        glm::vec3(3, -1, -5), glm::vec3(-6, 0, 0), glm::vec3(0, 0, 6),
        makeVerde()));
}

static void buildLights(World& world) {
    world.addLight(std::make_shared<PointLight>(glm::vec3(2, 2, 0), RED));
    world.addLight(std::make_shared<PointLight>(glm::vec3(-2, 2, -3), WHITE));
}

int main() {
    std::ofstream outFile("1.ppm");
    Film   film(1920, 1080, outFile);
    Camera camera(film, glm::vec3(0, 0, 3), glm::vec3(0, 0, 0), glm::vec3(0, 1, 0), 60, 1);

    Scene scene;   buildScene(scene);
    World world(&scene); buildLights(world);

    Renderer(&film, &camera, &world).Render(100);
    return 0;
}

#endif
#pragma endregion

#pragma region Escena 2
#if SCENE == 2

static std::shared_ptr<Material> makeMirror() { return std::make_shared<Material>(WHITE, 0.02f); }
static std::shared_ptr<Material> makeGlowing(Color c) { return std::make_shared<Material>(c, 0.9f); }

static std::shared_ptr<Material> makeCheckerDark() {
    return std::make_shared<Material>(grid(WHITE, BLACK, 6, 6), 0.3f);
}

static std::shared_ptr<Material> makeBase() {
    return std::make_shared<Material>(
        grid(Color(0.10f, 0.10f, 0.15f), Color(0.05f, 0.05f, 0.10f), 10, 10),
        0.15f);
}

static void buildScene(Scene& scene) {
    // Suelo oscuro
    scene.addShape(std::make_shared<Quad>(
        glm::vec3(5, -2, -8), glm::vec3(-10, 0, 0), glm::vec3(0, 0, 10),
        makeBase()));

    // Esfera central espejo
    scene.addShape(std::make_shared<Sphere>(glm::vec3(0, 0, -2), 1.2f, makeMirror()));

    // Anillo orbital
    constexpr int   N = 6;
    constexpr float R = 3.0f;
    const Color orbitColors[N] = { RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA };
    for (int i = 0; i < N; ++i) {
        float angle = 2.0f * glm::pi<float>() * i / N;
        glm::vec3 pos(R * std::cos(angle), 0.5f * std::sin(angle * 2), -2 + R * std::sin(angle));
        scene.addShape(std::make_shared<Sphere>(pos, 0.4f, makeGlowing(orbitColors[i])));
    }

    // Esferas checker flotantes
    scene.addShape(std::make_shared<Sphere>(glm::vec3(-1, 2.5f, -1), 0.50f, makeCheckerDark()));
    scene.addShape(std::make_shared<Sphere>(glm::vec3(1, 3.0f, -3), 0.35f, makeCheckerDark()));
    scene.addShape(std::make_shared<Sphere>(glm::vec3(0, 1.8f, 0), 0.25f, makeCheckerDark()));

    // Fragmentos geometricos flotantes
    scene.addShape(std::make_shared<Quad>(
        glm::vec3(-1.5f, 1.0f, -4), glm::vec3(2.0f, 0.3f, 0), glm::vec3(0, 1.5f, 0.5f),
        makeGlowing(CYAN)));
    scene.addShape(std::make_shared<Quad>(
        glm::vec3(1.0f, 0.5f, -5), glm::vec3(-1.5f, 0.2f, 0), glm::vec3(0, 1.2f, -0.4f),
        makeGlowing(MAGENTA)));
}

static void buildLights(World& world) {
    world.addLight(std::make_shared<PointLight>(glm::vec3(4, 3, 1), RED));
    world.addLight(std::make_shared<PointLight>(glm::vec3(-4, 2, 1), BLUE));
    world.addLight(std::make_shared<PointLight>(glm::vec3(0, 4, -4), GREEN));
    world.addLight(std::make_shared<PointLight>(glm::vec3(3, -1, -4), YELLOW));
    world.addLight(std::make_shared<PointLight>(glm::vec3(-3, 1, -5), CYAN));
    world.addLight(std::make_shared<PointLight>(glm::vec3(0, 5, 0), WHITE));
}

int main() {
    std::ofstream outFile("2.ppm");
    Film   film(1920, 1080, outFile);
    Camera camera(film, glm::vec3(0, 1.5f, 6), glm::vec3(0, 0, -2), glm::vec3(0, 1, 0), 55, 10);

    Scene scene;         buildScene(scene);
    World world(&scene); buildLights(world);

    Renderer(&film, &camera, &world).Render(50);
    return 0;
}

#endif
#pragma endregion

#pragma region Escena 3
#if SCENE == 3

static std::shared_ptr<Material> makeFloor() {
    return std::make_shared<Material>(
        grid(Color(0.85f, 0.85f, 0.85f), Color(0.15f, 0.05f, 0.05f), 12, 12), 0.4f);
}
static std::shared_ptr<Material> makeBackWall() {
    return std::make_shared<Material>(
        grid(Color(0.08f, 0.08f, 0.25f), Color(0.45f, 0.45f, 0.5f), 16, 2), 0.2f);
}
static std::shared_ptr<Material> makeSideWall() {
    return std::make_shared<Material>(
        nestedGrid(Color(0.0f, 0.40f, 0.10f), Color(0.0f, 0.25f, 0.05f),
            Color(0.6f, 0.80f, 0.20f), 4, 4, 3, 3), 0.3f);
}
static std::shared_ptr<Material> makeCheckerSphere() {
    return std::make_shared<Material>(grid(WHITE, BLACK, 10, 10), 0.5f);
}
static std::shared_ptr<Material> makeOrangeSphere() {
    return std::make_shared<Material>(
        nestedGrid(Color(1.0f, 0.5f, 0.0f), Color(0.6f, 0.2f, 0.0f),
            Color(0.9f, 0.8f, 0.1f), 6, 6, 2, 2), 0.6f);
}
static std::shared_ptr<Material> makeStripedSphere() {
    return std::make_shared<Material>(
        grid(Color(0.0f, 0.8f, 0.8f), Color(0.5f, 0.0f, 0.7f), 1, 12), 0.35f);
}
static std::shared_ptr<Material> makeFloatingQuad() {
    return std::make_shared<Material>(
        grid(Color(1.0f, 0.9f, 0.0f), Color(0.05f, 0.05f, 0.05f), 8, 8), 0.7f);
}

static void buildScene(Scene& scene) {
    // Sala
    scene.addShape(std::make_shared<Quad>(
        glm::vec3(5, -1.5f, -8), glm::vec3(-10, 0, 0), glm::vec3(0, 0, 10), makeFloor()));
    scene.addShape(std::make_shared<Quad>(
        glm::vec3(-5, -1.5f, -7), glm::vec3(10, 0, 0), glm::vec3(0, 6, 0), makeBackWall()));
    scene.addShape(std::make_shared<Quad>(
        glm::vec3(-5, -1.5f, 2), glm::vec3(0, 0, -9), glm::vec3(0, 6, 0), makeSideWall()));

    // Esferas
    scene.addShape(std::make_shared<Sphere>(glm::vec3(0.0f, 0.0f, -2), 1.1f, makeCheckerSphere()));
    scene.addShape(std::make_shared<Sphere>(glm::vec3(2.5f, -0.3f, -3), 0.8f, makeOrangeSphere()));
    scene.addShape(std::make_shared<Sphere>(glm::vec3(-2.5f, 0.2f, -3), 0.9f, makeStripedSphere()));
    scene.addShape(std::make_shared<Sphere>(glm::vec3(0.0f, 2.0f, -2), 0.4f,
        std::make_shared<Material>(grid(RED, WHITE, 8, 8), 0.5f)));

    // Quad flotante
    scene.addShape(std::make_shared<Quad>(
        glm::vec3(-1.5f, 1.2f, -5), glm::vec3(3.0f, 0.4f, 0), glm::vec3(0, 1.8f, 0.6f),
        makeFloatingQuad()));
}

static void buildLights(World& world) {
    world.addLight(std::make_shared<PointLight>(glm::vec3(3, 4, 1), WHITE));
    world.addLight(std::make_shared<PointLight>(glm::vec3(-3, 3, -2), Color(0.6f, 0.6f, 1.0f)));
    world.addLight(std::make_shared<PointLight>(glm::vec3(0, 2, 2), Color(1.0f, 0.8f, 0.5f)));
    world.addLight(std::make_shared<PointLight>(glm::vec3(0, -1, -5), Color(0.3f, 0.0f, 0.5f)));
}

int main() {
    std::ofstream outFile("3.ppm");
    Film   film(1920, 1080, outFile);
    Camera camera(film, glm::vec3(0, 1.0f, 5), glm::vec3(0, 0.0f, -2), glm::vec3(0, 1, 0), 60, 5);

    Scene scene;         buildScene(scene);
    World world(&scene); buildLights(world);

    Renderer(&film, &camera, &world).Render(2);
    return 0;
}

#endif
#pragma endregion
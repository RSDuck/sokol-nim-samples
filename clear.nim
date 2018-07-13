# just clears the framebuffer:
#
#   - basic initialization and draw loop
#   - clearing through a pass action

import glfw3 as glfw
import sokol/gfx as sg

# initialize GLFW and sokol-gfx
if glfw.Init() != 1:
    quit(QUIT_FAILURE)
glfw.WindowHint(CONTEXT_VERSION_MAJOR, 3)
glfw.WindowHint(CONTEXT_VERSION_MINOR, 3)
glfw.WindowHint(OPENGL_PROFILE, OPENGL_CORE_PROFILE)
glfw.WindowHint(OPENGL_FORWARD_COMPAT, 1)
let win = glfw.CreateWindow(640, 480, "Clear (sokol-nim)", nil, nil)
glfw.MakeContextCurrent(win)
when defined(windows):
    discard gladLoadGL()
sg.setup(sg.desc())

# a pass action (clear to color)
var pass_action = sg.pass_action(
    colors: %[
        color_attachment_action(action: ACTION_CLEAR, val: [1.0f, 0.0f, 0.0f, 1.0f])
    ]
)

# draw loop
while glfw.WindowShouldClose(win) == 0:
    # animate clear color
    var g = (pass_action.colors[0].val[1] + 0.01f)
    if g > 1.0f: g = 0.0f
    pass_action.colors[0].val[1] = g;

    var w, h: cint
    glfw.GetFramebufferSize(win, addr(w), addr(h))
    sg.begin_default_pass(pass_action, w, h)
    sg.end_pass()
    sg.commit()
    glfw.PollEvents()
    glfw.SwapBuffers(win)

sg.shutdown()
glfw.Terminate()

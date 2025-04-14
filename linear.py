import tkinter as tk
from tkinter import filedialog, messagebox
from PIL import Image, ImageTk
import numpy as np
from scipy.ndimage import affine_transform

def load_image(path):
    img = Image.open(path).convert("RGB")
    return np.array(img)

def save_image(array, path):
    img = Image.fromarray(np.clip(array, 0, 255).astype(np.uint8))
    img.save(path)

def apply_transformation(image_array, matrix):
    from scipy.ndimage import affine_transform

    # Extend image array to shape (H, W, 3) → (H, W, 1, 3)
    h, w, c = image_array.shape
    padded = np.zeros((h, w, 1, c))
    padded[:, :, 0, :] = image_array

    center = np.array([w / 2, h / 2, 0])
    transform_matrix = np.eye(4)
    transform_matrix[:3, :3] = matrix

    offset = center - matrix @ center

    result = np.zeros_like(padded)
    for i in range(3):
        result[..., 0, i] = affine_transform(
            padded[..., 0, i],
            matrix[:2, :2],
            offset=offset[:2],
            order=1,
            mode='constant',
            cval=0.0
        )

    return np.clip(result[:, :, 0, :], 0, 255).astype(np.uint8)

class ImageTransformerApp:
    def __init__(self, master):
        self.master = master
        self.master.title("Trasformazioni Lineari Interattive")

        self.original_image = None
        self.transformed_image = None

        self.build_ui()

    def build_ui(self):
        # Controlli
        controls = tk.Frame(self.master)
        controls.pack(pady=5)

        tk.Button(controls, text="Carica Immagine", command=self.load_image).grid(row=0, column=0, padx=5)
        tk.Button(controls, text="Applica Trasformazione", command=self.apply).grid(row=0, column=1, padx=5)
        tk.Button(controls, text="Salva Immagine", command=self.save).grid(row=0, column=2, padx=5)

        # Slider
        sliders = tk.LabelFrame(self.master, text="Parametri Trasformazione", padx=10, pady=10)
        sliders.pack(fill="x", padx=10)

        self.angle_var = tk.DoubleVar(value=0)
        self.angle_x_var = tk.DoubleVar(value=0)
        self.angle_y_var = tk.DoubleVar(value=0)
        self.scale_x_var = tk.DoubleVar(value=1)
        self.scale_y_var = tk.DoubleVar(value=1)
        self.flip_x_var = tk.BooleanVar()
        self.flip_y_var = tk.BooleanVar()

        tk.Label(sliders, text="Rotazione (°)").grid(row=0, column=0, sticky="w")
        tk.Scale(sliders, variable=self.angle_var, from_=-180, to=180, orient="horizontal", resolution=1).grid(row=0, column=1)

        tk.Label(sliders, text="Rotazione X (°)").grid(row=4, column=0, sticky="w")
        tk.Scale(sliders, variable=self.angle_x_var, from_=-180, to=180, orient="horizontal", resolution=1).grid(row=4, column=1)

        tk.Label(sliders, text="Rotazione Y (°)").grid(row=5, column=0, sticky="w")
        tk.Scale(sliders, variable=self.angle_y_var, from_=-180, to=180, orient="horizontal", resolution=1).grid(row=5, column=1)

        tk.Label(sliders, text="Scala X").grid(row=1, column=0, sticky="w")
        tk.Scale(sliders, variable=self.scale_x_var, from_=0.1, to=3.0, resolution=0.1, orient="horizontal").grid(row=1, column=1)

        tk.Label(sliders, text="Scala Y").grid(row=2, column=0, sticky="w")
        tk.Scale(sliders, variable=self.scale_y_var, from_=0.1, to=3.0, resolution=0.1, orient="horizontal").grid(row=2, column=1)

        tk.Checkbutton(sliders, text="Rifletti X", variable=self.flip_x_var).grid(row=3, column=0, sticky="w")
        tk.Checkbutton(sliders, text="Rifletti Y", variable=self.flip_y_var).grid(row=3, column=1, sticky="w")

        # Canvas
        self.canvas_frame = tk.Frame(self.master)
        self.canvas_frame.pack(pady=10)

        self.canvas_original = tk.Label(self.canvas_frame)
        self.canvas_original.pack(side=tk.LEFT, padx=10)

        self.canvas_transformed = tk.Label(self.canvas_frame)
        self.canvas_transformed.pack(side=tk.RIGHT, padx=10)

    def load_image(self):
        path = filedialog.askopenfilename(filetypes=[("Image Files", "*.png *.jpg *.jpeg *.bmp")])
        if not path:
            return
        self.original_image = load_image(path)
        self.show_image(self.original_image, self.canvas_original, is_transformed=False)

    def build_matrix(self):
        angle_z = np.radians(self.angle_var.get())
        angle_x = np.radians(self.angle_x_var.get())
        angle_y = np.radians(self.angle_y_var.get())

        scale_x = self.scale_x_var.get()
        scale_y = self.scale_y_var.get()
        flip_x = -1 if self.flip_x_var.get() else 1
        flip_y = -1 if self.flip_y_var.get() else 1

        # Rotation matrices for X, Y, Z
        Rx = np.array([
            [1, 0, 0],
            [0, np.cos(angle_x), -np.sin(angle_x)],
            [0, np.sin(angle_x),  np.cos(angle_x)]
        ])
        Ry = np.array([
            [np.cos(angle_y), 0, np.sin(angle_y)],
            [0, 1, 0],
            [-np.sin(angle_y), 0, np.cos(angle_y)]
        ])
        Rz = np.array([
            [np.cos(angle_z), -np.sin(angle_z), 0],
            [np.sin(angle_z),  np.cos(angle_z), 0],
            [0, 0, 1]
        ])
        rotation_matrix = Rz @ Ry @ Rx

        scale_matrix = np.diag([scale_x * flip_x, scale_y * flip_y, 1])

        return rotation_matrix @ scale_matrix

    def apply(self):
        if self.original_image is None:
            messagebox.showerror("Errore", "Carica prima un'immagine.")
            return

        matrix = self.build_matrix()
        self.transformed_image = apply_transformation(self.original_image, matrix)
        self.show_image(self.transformed_image, self.canvas_transformed, is_transformed=True)

    def save(self):
        if self.transformed_image is None:
            messagebox.showerror("Errore", "Nessuna immagine trasformata.")
            return
        path = filedialog.asksaveasfilename(defaultextension=".png", filetypes=[("PNG Image", "*.png")])
        if path:
            save_image(self.transformed_image, path)
            messagebox.showinfo("Successo", f"Immagine salvata in:\n{path}")

    def show_image(self, img_array, canvas, is_transformed=False):
        image = Image.fromarray(img_array)
        max_size = (600, 1000) if is_transformed else (300, 300)
        image.thumbnail(max_size)
        tk_img = ImageTk.PhotoImage(image)
        canvas.configure(image=tk_img)
        canvas.image = tk_img

if __name__ == "__main__":
    root = tk.Tk()
    app = ImageTransformerApp(root)
    root.mainloop()

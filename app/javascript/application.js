// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { createIcons, LayoutDashboard, Library, Wand2, Github, ChevronRight, Palette, Sparkles, Download } from "lucide"

const initIcons = () => createIcons({ icons: { LayoutDashboard, Library, Wand2, Github, ChevronRight, Palette, Sparkles, Download } })

document.addEventListener("turbo:load", initIcons)
document.addEventListener("DOMContentLoaded", initIcons)

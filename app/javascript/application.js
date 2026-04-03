// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { createIcons, LayoutDashboard, Library, Wand2, ChevronRight, Palette, Sparkles, Download, Copy, AlertCircle } from "lucide"

const initIcons = () => createIcons({ icons: { LayoutDashboard, Library, Wand2, ChevronRight, Palette, Sparkles, Download, Copy, AlertCircle } })

document.addEventListener("turbo:load", initIcons)
document.addEventListener("DOMContentLoaded", initIcons)

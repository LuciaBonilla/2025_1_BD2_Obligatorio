import { Routes, Route, Navigate } from "react-router-dom";

// RUTAS.
import routes from "@/constants/routes";

// RUTA PROTEGIDA@
import ProtectedRoute from "@/routes-protection/ProtectedRoute";

// 9 PAGES.
import PingPongPage from "@/pages/PingPongPage";
import RegisterPage from "@/pages/RegisterPage";
import MyFeedPage from "@/pages/MyFeedPage";
import MyProfilePage from "@/pages/MyProfilePage";
import CreatePostPage from "@/pages/CreatePostPage";
import EditMyProfilePage from "@/pages/EditMyProfilePage";
import MyPostPage from "@/pages/MyPostPage";
import OtherUserProfilePage from "@/pages/OtherUserProfilePage";
import OtherUserPostPage from "@/pages/OtherUserPostPage";

/**
 * Define las rutas públicas y las rutas privadas.
 * @estado TERMINADO.
 */
export default function AppRouter() {
  return (
    <>
      <Routes>
        {/* Rutas públicas. */}
        <Route
          path={routes.LOGIN_ROUTE}
          element={<LoginPage />}
        />
        {/* Redirige de "/" a LOGIN_ROUTE directamente. */}
        <Route
          path="/"
          element={<Navigate to={routes.LOGIN_ROUTE} />}
        />
        <Route
          path="*"
          element={<h1>Página no encontrada.</h1>}
        />

        {/* Rutas privadas. */}
        <Route
          path={routes.MY_FEED_ROUTE}
          element={
            <ProtectedRoute>
              <MyFeedPage />
            </ProtectedRoute>
          }
        />
        <Route
          path={routes.CREATE_POST_ROUTE}
          element={
            <ProtectedRoute>
              <CreatePostPage />
            </ProtectedRoute>
          }
        />
        <Route
          path={routes.MY_PROFILE_ROUTE}
          element={
            <ProtectedRoute>
              <MyProfilePage />
            </ProtectedRoute>
          }
        />
        <Route
          path={routes.MY_PROFILE_EDIT_ROUTE}
          element={
            <ProtectedRoute>
              <EditMyProfilePage />
            </ProtectedRoute>
          }
        />
        <Route
          path={routes.MY_POSTS_ROUTE}
          element={
            <ProtectedRoute>
              <MyPostPage />
            </ProtectedRoute>
          }
        />
        <Route
          path={routes.OTHER_USER_PROFILE_ROUTE}
          element={
            <ProtectedRoute>
              <OtherUserProfilePage />
            </ProtectedRoute>
          }
        />
        <Route
          path={routes.OTHER_USER_POST_ROUTE}
          element={
            <ProtectedRoute>
              <OtherUserPostPage />
            </ProtectedRoute>
          }
        />
      </Routes>
    </>
  )
}
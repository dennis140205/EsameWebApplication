import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { AuthService } from './auth.service';

export const AuthGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);
  const checkPermissions = () => {
    const user = authService.getUserSnapshot();

    if (state.url.startsWith('/admin')) {
      if (user && user.email === 'admin@admin.com') {
        return true;
      }
      console.warn('Accesso Admin negato per:', user?.email);
      router.navigate(['/']);
      return false;
    }
    return true;
  };

  if (authService.isLoggedInSnapshot()) {
    console.log('AuthGuard: Stato locale TRUE, accesso concesso immediatamente.');
    return checkPermissions();
  }

  console.log('AuthGuard: Stato locale FALSE, verifico con il backend...');

  return authService.checkAuthStatus().pipe(
    map(isAuthenticated => {
      if (isAuthenticated) {
        return checkPermissions();
      }

      router.navigate(['/login']);
      return false;
    }),
    catchError(() => {
      router.navigate(['/login']);
      return of(false);
    })
  );
};

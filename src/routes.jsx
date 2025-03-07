import Landing from './components/Landing';
import Dashboard from './components/Dashboard';
import CarbonPools from './pages/carbon_pools';
import Explorer from './pages/explorer';
import CrossChain from './pages/cross_chain';
import Retirements from './pages/retirements';
import NDVIAnalyzer from './pages/ndvi_analyzer';
import Companies from './pages/companies';
import Admin from './pages/admin';

// Main application routes
export const mainRoutes = [
  {
    path: '/',
    element: <Landing />,
    exact: true,
  },
  {
    path: '/about',
    element: <div className="pt-16">About Page (Coming Soon)</div>,
  },
  {
    path: '/resources',
    element: <div className="pt-16">Resources (Coming Soon)</div>,
  },
  {
    path: '/news',
    element: <div className="pt-16">News (Coming Soon)</div>,
  },
];

// Dashboard routes
export const dashboardRoutes = [
  {
    path: '/dashboard',
    element: <Dashboard />,
    exact: true,
  },
  {
    path: '/dashboard/carbon-pools',
    element: <CarbonPools />,
  },
  {
    path: '/dashboard/explorer',
    element: <Explorer />,
  },
  {
    path: '/dashboard/cross-chain',
    element: <CrossChain />,
  },
  {
    path: '/dashboard/retirements',
    element: <Retirements />,
  },
  {
    path: '/dashboard/ndvi-analyzer',
    element: <NDVIAnalyzer />,
  },
  {
    path: '/dashboard/companies',
    element: <Companies />,
  },
  {
    path: '/dashboard/admin',
    element: <Admin />,
  },
]; 
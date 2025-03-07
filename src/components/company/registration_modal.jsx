import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { registerCompany } from '../../services/auth_service';
import { useWallet } from '../../context/wallet_context';
import metamaskIcon from '../../assets/metamask.png';

const RegistrationModal = ({ isOpen, onClose }) => {
  const { walletAddress, setCompanyData } = useWallet();
  const [step, setStep] = useState(1); // 1: Form, 2: Verification, 3: Success
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);
  
  // Form state
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    website: '',
    industry: '',
    description: '',
    contactPerson: '',
    contactPhone: ''
  });
  
  // Handle input change
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    
    // Clear error when user types
    if (error) setError(null);
  };
  
  // Validate email domain
  const validateEmail = (email) => {
    // Check if it's a valid email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) return false;
    
    // Check if it's not a free email provider
    const domain = email.split('@')[1];
    const freeEmailProviders = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'aol.com', 'icloud.com'];
    
    if (freeEmailProviders.includes(domain)) return false;
    
    return true;
  };
  
  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Validate form
    if (!formData.name || !formData.email || !formData.industry) {
      setError('Please fill in all required fields.');
      return;
    }
    
    // Validate email domain
    if (!validateEmail(formData.email)) {
      setError('Please use a valid company email domain. Free email providers are not allowed.');
      return;
    }
    
    try {
      setIsSubmitting(true);
      setError(null);
      
      // Register company
      const result = await registerCompany({
        ...formData,
        walletAddress,
      });
      
      if (result.success) {
        // Move to verification step
        setStep(2);
        
        // In a real app, we would wait for email verification
        // For demo purposes, we'll simulate success after 3 seconds
        setTimeout(() => {
          setStep(3);
          
          // Update the wallet context with the new company
          setCompanyData(result.companyId, {
            ...formData,
            walletAddress,
            registrationDate: new Date(),
            isVerified: true,
            tokenBalances: {
              carbonCredits: 0
            },
            transactions: []
          });
          
          // Close modal after another 2 seconds
          setTimeout(() => {
            onClose();
          }, 2000);
        }, 3000);
      } else {
        setError(result.error);
      }
    } catch (error) {
      setError(error.message);
    } finally {
      setIsSubmitting(false);
    }
  };
  
  // Modal backdrop variants
  const backdropVariants = {
    hidden: { opacity: 0 },
    visible: { opacity: 1 }
  };
  
  // Modal content variants
  const modalVariants = {
    hidden: { opacity: 0, y: 50, scale: 0.95 },
    visible: { opacity: 1, y: 0, scale: 1, transition: { type: 'spring', damping: 20, stiffness: 300 } }
  };
  
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          className="fixed inset-0 bg-[#0F172A]/90 backdrop-blur-sm z-50 flex items-center justify-center p-4"
          variants={backdropVariants}
          initial="hidden"
          animate="visible"
          exit="hidden"
        >
          <motion.div
            className="bg-[#1E293B] border border-[#76EAD7]/20 rounded-2xl w-full max-w-2xl overflow-hidden shadow-xl"
            variants={modalVariants}
            initial="hidden"
            animate="visible"
            exit="hidden"
          >
            {/* Modal Header */}
            <div className="border-b border-[#76EAD7]/10 px-6 py-4 flex justify-between items-center">
              <h3 className="text-xl font-semibold text-white">
                {step === 1 && 'Register Your Company'}
                {step === 2 && 'Verifying Your Email'}
                {step === 3 && 'Registration Complete'}
              </h3>
              <button
                onClick={onClose}
                className="text-[#94A3B8] hover:text-white transition-colors"
                disabled={isSubmitting}
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            
            {/* Modal Body */}
            <div className="p-6">
              {/* Step 1: Registration Form */}
              {step === 1 && (
                <form onSubmit={handleSubmit}>
                  {/* Company Information */}
                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium text-[#94A3B8] mb-1">
                        Company Name *
                      </label>
                      <input
                        type="text"
                        name="name"
                        value={formData.name}
                        onChange={handleChange}
                        className="w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 text-white"
                        placeholder="Your company name"
                        required
                      />
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-[#94A3B8] mb-1">
                        Company Email *
                      </label>
                      <input
                        type="email"
                        name="email"
                        value={formData.email}
                        onChange={handleChange}
                        className="w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 text-white"
                        placeholder="email@yourcompany.com"
                        required
                      />
                      <p className="text-xs text-[#94A3B8] mt-1">
                        Please use your company email domain (e.g., @yourcompany.com). Free email providers are not allowed.
                      </p>
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-[#94A3B8] mb-1">
                        Website
                      </label>
                      <input
                        type="url"
                        name="website"
                        value={formData.website}
                        onChange={handleChange}
                        className="w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 text-white"
                        placeholder="https://yourcompany.com"
                      />
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-[#94A3B8] mb-1">
                        Industry *
                      </label>
                      <select
                        name="industry"
                        value={formData.industry}
                        onChange={handleChange}
                        className="w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 text-white"
                        required
                      >
                        <option value="">Select an industry</option>
                        <option value="Energy">Energy</option>
                        <option value="Manufacturing">Manufacturing</option>
                        <option value="Transportation">Transportation</option>
                        <option value="Agriculture">Agriculture</option>
                        <option value="Technology">Technology</option>
                        <option value="Finance">Finance</option>
                        <option value="Retail">Retail</option>
                        <option value="Other">Other</option>
                      </select>
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-[#94A3B8] mb-1">
                        Company Description
                      </label>
                      <textarea
                        name="description"
                        value={formData.description}
                        onChange={handleChange}
                        className="w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 text-white"
                        placeholder="Brief description of your company"
                        rows={3}
                      />
                    </div>
                    
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-[#94A3B8] mb-1">
                          Contact Person
                        </label>
                        <input
                          type="text"
                          name="contactPerson"
                          value={formData.contactPerson}
                          onChange={handleChange}
                          className="w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 text-white"
                          placeholder="Full name"
                        />
                      </div>
                      
                      <div>
                        <label className="block text-sm font-medium text-[#94A3B8] mb-1">
                          Contact Phone
                        </label>
                        <input
                          type="tel"
                          name="contactPhone"
                          value={formData.contactPhone}
                          onChange={handleChange}
                          className="w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 text-white"
                          placeholder="Phone number"
                        />
                      </div>
                    </div>
                    
                    {/* Connected Wallet */}
                    <div className="mt-4 p-3 bg-[#0F172A]/80 rounded-lg border border-[#76EAD7]/10">
                      <div className="flex items-center">
                        <div className="flex-shrink-0">
                        <img src={metamaskIcon} alt="MetaMask" className="w-5 h-5 mr-2" />
                        </div>
                        <div className="ml-3">
                          <p className="text-sm font-medium text-white">Connected MetaMask Wallet</p>
                          <p className="text-xs text-[#94A3B8] truncate max-w-xs">{walletAddress}</p>
                        </div>
                      </div>
                    </div>
                    
                    {/* Error message */}
                    {error && (
                      <div className="mt-4 p-3 bg-red-500/10 border border-red-500/20 rounded-lg">
                        <p className="text-sm text-red-400">{error}</p>
                      </div>
                    )}
                  </div>
                  
                  {/* Submit button */}
                  <div className="mt-6 flex justify-end">
                    <button
                      type="button"
                      onClick={onClose}
                      className="px-4 py-2 text-[#94A3B8] hover:text-white transition-colors mr-3"
                      disabled={isSubmitting}
                    >
                      Cancel
                    </button>
                    <button
                      type="submit"
                      className="px-6 py-2 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold rounded-lg hover:shadow-lg transition-all disabled:opacity-70"
                      disabled={isSubmitting}
                    >
                      {isSubmitting ? 'Registering...' : 'Register Company'}
                    </button>
                  </div>
                </form>
              )}
              
              {/* Step 2: Email Verification */}
              {step === 2 && (
                <div className="text-center py-8">
                  <div className="mx-auto w-16 h-16 border-4 border-[#76EAD7]/30 border-t-[#76EAD7] rounded-full animate-spin mb-6"></div>
                  <h3 className="text-xl font-semibold text-white mb-2">Verifying Your Email</h3>
                  <p className="text-[#94A3B8] mb-4">
                    We've sent a verification email to <span className="text-[#76EAD7]">{formData.email}</span>.
                  </p>
                  <p className="text-[#94A3B8]">
                    Please check your inbox and follow the instructions to complete your registration.
                  </p>
                </div>
              )}
              
              {/* Step 3: Success */}
              {step === 3 && (
                <div className="text-center py-8">
                  <div className="mx-auto w-16 h-16 bg-[#76EAD7]/10 rounded-full flex items-center justify-center mb-6">
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <h3 className="text-xl font-semibold text-white mb-2">Registration Complete!</h3>
                  <p className="text-[#94A3B8] mb-4">
                    Your company has been successfully registered on the CarbonX platform.
                  </p>
                  <p className="text-[#94A3B8]">
                    You can now start trading carbon credits and managing your company's sustainability initiatives.
                  </p>
                </div>
              )}
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default RegistrationModal; 
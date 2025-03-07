import { useState } from 'react';
import { motion } from 'framer-motion';
import { approveCompany, rejectCompany } from '../../services/auth_service';

const CompanyVerificationCard = ({ company, onStatusChange }) => {
  const [isExpanded, setIsExpanded] = useState(false);
  const [rejectionReason, setRejectionReason] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showRejectionForm, setShowRejectionForm] = useState(false);
  
  // Format date
  const formatDate = (date) => {
    if (!date) return 'N/A';
    
    if (typeof date === 'string') {
      date = new Date(date);
    }
    
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    }).format(date);
  };
  
  // Handle company approval
  const handleApprove = async () => {
    try {
      setIsSubmitting(true);
      const result = await approveCompany(company.id);
      
      if (result.success) {
        onStatusChange && onStatusChange(company.id, 'approved');
      }
    } catch (error) {
      console.error("Error approving company:", error);
    } finally {
      setIsSubmitting(false);
    }
  };
  
  // Handle company rejection
  const handleReject = async () => {
    if (!rejectionReason.trim()) {
      return; // Don't submit if reason is empty
    }
    
    try {
      setIsSubmitting(true);
      const result = await rejectCompany(company.id, rejectionReason);
      
      if (result.success) {
        onStatusChange && onStatusChange(company.id, 'rejected');
        setShowRejectionForm(false);
      }
    } catch (error) {
      console.error("Error rejecting company:", error);
    } finally {
      setIsSubmitting(false);
    }
  };
  
  return (
    <motion.div
      className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl overflow-hidden border border-[#76EAD7]/10 mb-4"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
    >
      {/* Card header */}
      <div className="p-4 sm:p-6 flex flex-col sm:flex-row sm:items-center justify-between">
        <div>
          <div className="flex items-center">
            <div className="w-10 h-10 bg-[#76EAD7]/10 rounded-full flex items-center justify-center mr-3">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M4 4a2 2 0 012-2h8a2 2 0 012 2v12a1 1 0 01-1 1h-2a1 1 0 01-1-1v-2a1 1 0 00-1-1H7a1 1 0 00-1 1v2a1 1 0 01-1 1H3a1 1 0 01-1-1V4zm3 1h2v2H7V5zm2 4H7v2h2V9zm2-4h2v2h-2V5zm2 4h-2v2h2V9z" clipRule="evenodd" />
              </svg>
            </div>
            <div>
              <h3 className="text-lg font-semibold text-white">{company.name}</h3>
              <p className="text-[#94A3B8] text-sm">{company.industry}</p>
            </div>
          </div>
        </div>
        
        <div className="mt-4 sm:mt-0 flex items-center">
          <div className="text-[#94A3B8] text-sm mr-4">
            <span>Registered: {formatDate(company.registrationDate)}</span>
          </div>
          
          <button
            onClick={() => setIsExpanded(!isExpanded)}
            className="text-[#76EAD7] hover:text-white transition-colors"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className={`h-5 w-5 transform transition-transform duration-300 ${isExpanded ? 'rotate-180' : ''}`} viewBox="0 0 20 20" fill="currentColor">
              <path fillRule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clipRule="evenodd" />
            </svg>
          </button>
        </div>
      </div>
      
      {/* Card details */}
      {isExpanded && (
        <div className="border-t border-[#76EAD7]/10 p-4 sm:p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <h4 className="text-[#94A3B8] font-medium mb-3">Company Information</h4>
              
              <div className="space-y-3">
                <div>
                  <p className="text-[#94A3B8] text-xs">Email</p>
                  <p className="text-white">{company.email}</p>
                </div>
                
                {company.website && (
                  <div>
                    <p className="text-[#94A3B8] text-xs">Website</p>
                    <a href={company.website} target="_blank" rel="noopener noreferrer" className="text-[#76EAD7] hover:underline">
                      {company.website}
                    </a>
                  </div>
                )}
                
                {company.description && (
                  <div>
                    <p className="text-[#94A3B8] text-xs">Description</p>
                    <p className="text-white">{company.description}</p>
                  </div>
                )}
              </div>
            </div>
            
            <div>
              <h4 className="text-[#94A3B8] font-medium mb-3">Contact Information</h4>
              
              <div className="space-y-3">
                {company.contactPerson && (
                  <div>
                    <p className="text-[#94A3B8] text-xs">Contact Person</p>
                    <p className="text-white">{company.contactPerson}</p>
                  </div>
                )}
                
                {company.contactPhone && (
                  <div>
                    <p className="text-[#94A3B8] text-xs">Contact Phone</p>
                    <p className="text-white">{company.contactPhone}</p>
                  </div>
                )}
                
                <div>
                  <p className="text-[#94A3B8] text-xs">Wallet Address</p>
                  <p className="text-white font-mono text-sm break-all">{company.walletAddress}</p>
                </div>
              </div>
            </div>
          </div>
          
          {/* Actions */}
          <div className="mt-6 border-t border-[#76EAD7]/10 pt-4">
            {showRejectionForm ? (
              <div className="mt-4">
                <label className="block text-[#94A3B8] text-sm mb-2">Rejection Reason</label>
                <textarea
                  value={rejectionReason}
                  onChange={(e) => setRejectionReason(e.target.value)}
                  className="w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 text-white"
                  placeholder="Provide a reason for rejection"
                  rows={3}
                />
                <div className="mt-3 flex justify-end">
                  <button
                    type="button"
                    onClick={() => setShowRejectionForm(false)}
                    className="px-4 py-2 text-[#94A3B8] hover:text-white transition-colors mr-3"
                    disabled={isSubmitting}
                  >
                    Cancel
                  </button>
                  <button
                    type="button"
                    onClick={handleReject}
                    className="px-4 py-2 bg-red-500 text-white font-medium rounded-lg hover:bg-red-600"
                    disabled={isSubmitting || !rejectionReason.trim()}
                  >
                    {isSubmitting ? 'Rejecting...' : 'Confirm Rejection'}
                  </button>
                </div>
              </div>
            ) : (
              <div className="flex justify-end">
                <button
                  type="button"
                  onClick={() => setShowRejectionForm(true)}
                  className="px-4 py-2 border border-red-500 text-red-400 hover:bg-red-500/10 rounded-lg mr-3"
                  disabled={isSubmitting}
                >
                  Reject
                </button>
                <button
                  type="button"
                  onClick={handleApprove}
                  className="px-6 py-2 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-medium rounded-lg hover:shadow-lg"
                  disabled={isSubmitting}
                >
                  {isSubmitting ? 'Approving...' : 'Approve Company'}
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </motion.div>
  );
};

export default CompanyVerificationCard; 